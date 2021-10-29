import Foundation
import Kingfisher

typealias UserResult = (Result<User, ErrorHandlingDomain>) -> Void
typealias UsersResult = (Result<[User], ErrorHandlingDomain>) -> Void
typealias PostResult = (Result<Post, ErrorHandlingDomain>) -> Void
typealias PostsResult = (Result<[Post], ErrorHandlingDomain>) -> Void
typealias TokenResult = (Result<TokenModel, ErrorHandlingDomain>) -> Void
typealias EmptyResult = (Result<Void, ErrorHandlingDomain>) -> Void
typealias ImageCachingClosure = (Result<RetrieveImageResult, KingfisherError>) -> Void
// swiftlint:disable:next type_name

protocol ImageDataSavingAgent {
  func saveAvatarData(data: Data)
  func savePostImageData(data: Data)
}

public enum UsersListType {
  case followers, followings
}
