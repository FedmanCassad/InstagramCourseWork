import CoreData

protocol OfflineCacher {
  func saveCodableUserToPersistentStore(user: User)
  func saveCodablePostToPersistentStore(post: Post)
}

final class CoreDataService {
  private let modelName: String
  private let container: NSPersistentContainer
  private var context: NSManagedObjectContext!
  private var taskContext: NSManagedObjectContext!
  private var taskQueue: DispatchQueue = DispatchQueue(label: "CoreDataQueue", qos: .utility, attributes: .concurrent)

  init(dataModelName: String) {
    self.modelName = dataModelName
    self.container = NSPersistentContainer(name: dataModelName)
    setupStack()
  }

  func setupStack() {
    container.loadPersistentStores {[weak self] _, error in
      if let error = error {
        print(error.localizedDescription)
      } else {
      self?.context = self?.container.viewContext
        self?.taskQueue.async {
          self?.taskContext = self?.container.newBackgroundContext()
          self?.taskContext.mergePolicy = NSMergePolicy.overwrite
        }
      }
    }
  }

  func save() {
    taskContext.perform {
      if self.taskContext.hasChanges {
        do {
          try self.taskContext.save()
        } catch {
          self.taskContext.rollback()
        }
      }
    }
  }

  func createObject<T: NSManagedObject>() -> T {
    guard let name = T.entity().name,
          let object = NSEntityDescription.insertNewObject(forEntityName: name, into: taskContext) as? T
    else {
      fatalError("Cannot insert object")
    }
    return object
  }

  func deleteObject<T: NSManagedObject> (object: T) {
    taskContext.delete(object)
    save()
  }

  func fetchData<T: NSManagedObject> (
    for entity: T.Type,
    with predicate: NSCompoundPredicate? = nil,
    with sortDescriptors: [NSSortDescriptor]? = nil
  ) -> [T]? {
    let request: NSFetchRequest<T>
    var fetchedResult = [T]()
    request = NSFetchRequest(entityName: String(describing: entity))
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors
    do {
      fetchedResult = try taskContext.fetch(request)
    } catch {
      debugPrint("Error occurred: \(error.localizedDescription)")
    }
    return fetchedResult
  }
}
