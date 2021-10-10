import Foundation

protocol IPersistentDataProvider {
  var provider: CoreDataService { get }
  /// Получение текущего пользователя из хранилища.
  /// - Parameter handler: В замыкание приходит или не приходит объект типа User, через объект
  ///   Result<User, ErrorHandlingDomain>
  ///   Вызывается после выполнения запроса.
  func getCurrentUserFromPersistentStore() -> CDUser?

  /// Сохраняет userID текущего пользователя
  func saveCurrentUserID(with userID: User.ID)

  /// Сохранение текущего состояния контекста
  func saveUserToPersistentStore(user: User)

  /// Получаем сохраненный массив постов из ленты(все посты)
  func getFeedFromPersistentStore() -> [Post]

  /// Получаем юзера по ID
  func getSpecificUser(by id: User.ID) -> User?

  /// Получаем id сохраненного текущего юзера.
  func getCurrentUserID() -> String?

  /// Получать конкретные посты
  /// - Parameter keys: словарь ключей по которым будут запрошены посты. (обычно по userID(author))
  func getSpecificPostsFromPersistentStore(by keys: [String: Any]) -> [CDPost]

  /// Сохраняем все посты которые есть
  /// - Parameter posts: массив наших обычных Codable постов.
  func saveFeed(posts: [Post])
  /// Сохраняем пост
  /// - Parameter post: - пост для сохранения
  func savePost(post: Post)

  /// Удалить все сохраненные посты
  func deleteAllPostsFromPersistentStore()

  /// Удалить всех сохраненных юзеров
  func deleteAllUsersFromPersistentStore()
}

final class PersistentDataProvider: IPersistentDataProvider {

  func getCurrentUserID() -> String? {
    defer {
      LockingView.unlock()
    }
    guard let loggedUser = provider.fetchData(for: LoggedUser.self)?.first else { return nil }
    return loggedUser.id
  }

  static let shared = PersistentDataProvider()
  var provider: CoreDataService = CoreDataService(dataModelName: "OfflineCache")

  private init() {}

  func getCurrentUserFromPersistentStore() -> CDUser? {
    defer {
      LockingView.unlock()
    }
    guard let id = getCurrentUserID() else { return nil }
    let predicates = SearchPredicateConstructor.getPredicates(by: ["id": id])
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    guard let cdUser = provider.fetchData(for: CDUser.self, with: compoundPredicate)?.first
    else { return nil }
    return cdUser
  }

  func saveCurrentUserID(with userID: User.ID) {
    defer {
      LockingView.unlock()
    }
    let object: LoggedUser = provider.createObject()
    object.id = userID
    provider.save()
  }

  func saveUserToPersistentStore(user: User) {
    defer {
      LockingView.unlock()
    }
    let object: CDUser = provider.createObject()
    object.prepareFromCodableUser(user: user)
    provider.save()

  }

  func getFeedFromPersistentStore() -> [Post] {
    defer {
      LockingView.unlock()
    }
    let sortDescriptor = NSSortDescriptor(key: "createdTime", ascending: false)
    guard let posts = provider.fetchData(for: CDPost.self, with: nil, with: [sortDescriptor]) else {
      return [Post]()
    }
    return posts.compactMap { Post(from: $0) }
  }

  func getSpecificPostsFromPersistentStore(by keys: [String: Any]) -> [CDPost] {
    defer {
      LockingView.unlock()
    }
    let predicate = SearchPredicateConstructor.getPredicates(by: keys)
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
    guard let posts = provider.fetchData(for: CDPost.self, with: compoundPredicate) else { return [CDPost]() }
    return posts
  }

  func getSpecificUser(by id: User.ID) -> User? {
    defer {
      LockingView.unlock()
    }
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                  SearchPredicateConstructor.getUserPredicate(by: id))
    guard let user = provider.fetchData(for: CDUser.self, with: compoundPredicate)?.first else { return nil }
    return User(from: user)
  }

  func saveFeed(posts: [Post]) {
    defer {
      LockingView.unlock()
    }
    let _: [CDPost] = posts.map {
      let post: CDPost = provider.createObject()
      post.prepareFromCodablePost(post: $0)
      return post
    }
    provider.save()
  }

  func savePost(post: Post) {
    defer {
      LockingView.unlock()
    }
    let cdPost: CDPost = provider.createObject()
    cdPost.prepareFromCodablePost(post: post)
    provider.save()
  }

  func deleteAllPostsFromPersistentStore() {
    defer {
      LockingView.unlock()
    }
    guard let posts = provider.fetchData(for: CDPost.self) else { return }
    posts.forEach { provider.deleteObject(object: $0) }
  }

  func deleteAllUsersFromPersistentStore() {
    defer {
      LockingView.unlock()
    }
    guard let users = provider.fetchData(for: CDUser.self) else { return }
    users.forEach { provider.deleteObject(object: $0) }
  }

}
