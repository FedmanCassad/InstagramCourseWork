import CoreData

protocol Savable {
  var readyToSave: Bool { get }
  var performSaving: ((Savable) -> Void)? { get set }
}

class Post: Decodable, Identifiable, Hashable {
  var id, postDescription, author, authorUsername: String
  var image, authorAvatar: URL
  var createdTime: Date
  var currentUserLikesThisPost: Bool
  var likedByCount: Int
  var imageData: Data? {
    didSet {
      if readyToSave {
        performSaving?(self)
      }
    }
  }

  var avatarImageData: Data? {
    didSet {
      if readyToSave {
        performSaving?(self)
      }
    }
  }

  var performSaving: ((Savable) -> Void)?
  
  enum CodingKeys: String, CodingKey {
    case postDescription = "description"
    case
      id,
      createdTime,
      author,
      authorUsername,
      image,
      authorAvatar,
      currentUserLikesThisPost,
      likedByCount,
      imageData,
      avatarImageData
  }

  init?(from coreDataModel: CDPost) {
    guard
      let id = coreDataModel.id,
      let postDescription = coreDataModel.postDescription,
      let author = coreDataModel.author,
      let authorUsername = coreDataModel.authorUsername,
      let image = coreDataModel.image,
      let authorAvatar = coreDataModel.authorAvatar,
      let createdTime = coreDataModel.createdTime,
      let imageData = coreDataModel.imagePNGData,
      let avatarImageData = coreDataModel.avatarPNGData
    else { return nil }

    self.id = id
    self.postDescription = postDescription
    self.author = author
    self.authorUsername = authorUsername
    self.image = image
    self.authorAvatar = authorAvatar
    self.createdTime = createdTime
    self.imageData = imageData
    self.avatarImageData = avatarImageData
    self.currentUserLikesThisPost = coreDataModel.currentUserLikesThisPost
    self.likedByCount = Int(coreDataModel.likedByCount)
  }

  static func == (lhs: Post, rhs: Post) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(author)
  }
}

struct PostEncodableRequest: Encodable {
  let postID: Post.ID
}

struct PostUploadingRequest: Encodable {
  let image, description: String
}

extension Post: Savable {
  var readyToSave: Bool {
    imageData != nil && avatarImageData != nil
  }
}
