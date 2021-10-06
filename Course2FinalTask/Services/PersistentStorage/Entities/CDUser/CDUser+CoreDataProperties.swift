import CoreData
import Foundation

extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var avatar: URL?
    @NSManaged public var avatarData: Data?
    @NSManaged public var currentUserFollowsThisUser: Bool
    @NSManaged public var currentUserIsFollowedByThisUser: Bool
    @NSManaged public var followedCount: Int16
    @NSManaged public var followsCount: Int16
    @NSManaged public var fullName: String?
    @NSManaged public var id: String?
    @NSManaged public var username: String?

}

extension CDUser {
  @nonobjc func prepareFromCodableUser(user: User) {
    self.id = user.id
    self.avatar = user.avatar
    self.avatarData = user.avatarData
    self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
    self.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
    self.followedCount = Int16(user.followedByCount)
    self.followsCount = Int16(user.followsCount)
    self.fullName = user.fullName
    self.username = user.username
  }
}
