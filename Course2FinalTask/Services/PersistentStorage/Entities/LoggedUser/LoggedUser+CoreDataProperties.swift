import CoreData
import Foundation

extension LoggedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedUser> {
        return NSFetchRequest<LoggedUser>(entityName: "LoggedUser")
    }

    @NSManaged public var id: String?

}
