import Foundation

class User: Decodable, Identifiable, Hashable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(fullName)
  }

  var id, username, fullName: String
  var avatar: URL
  var currentUserFollowsThisUser, currentUserIsFollowedByThisUser: Bool
  var followsCount, followedByCount: Int
  var avatarData: Data? {
    didSet {
      guard readyToSave else {
        return
      }
      performSaving?(self)
    }
  }

  var performSaving: ((Savable) -> Void)?

  enum CodingKeys: String, CodingKey {
    case id, username, fullName, avatar, currentUserFollowsThisUser,
	currentUserIsFollowedByThisUser, followsCount, followedByCount
  }

  init?(from coreDataModel: CDUser) {
    guard
      let id = coreDataModel.id,
      let userName = coreDataModel.username,
      let fullName = coreDataModel.fullName,
      let avatar = coreDataModel.avatar,
      let avatarData = coreDataModel.avatarData
    else {
      return nil
    }
    self.id = id
    self.username = userName
    self.fullName = fullName
    self.avatar = avatar
    self.avatarData = avatarData
    self.currentUserFollowsThisUser = coreDataModel.currentUserFollowsThisUser
    self.currentUserIsFollowedByThisUser = coreDataModel.currentUserIsFollowedByThisUser
    self.followsCount = Int(coreDataModel.followsCount)
    self.followedByCount = Int(coreDataModel.followedCount)
  }
}

struct UserEncodableRequest: Encodable {
  let userID: User.ID
}

extension User: Savable {
  var readyToSave: Bool {
    avatarData != nil
  }
}
