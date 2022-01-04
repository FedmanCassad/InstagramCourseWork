import Foundation

enum NetworkRequestBuilder {

  var token: TokenModel {
    let token = KeychainService.getToken()
    return TokenModel(token: token ?? "")
  }

  case signIn(payload: SignInModel)
  case feed
  case getCurrentUser
  case findPosts
  case userFollowings
  case userFollowed
  case follow(userID: UserEncodableRequest)
  case unfollow(userID: UserEncodableRequest)
  case uploadPost(post: PostUploadingRequest)
  case getUser
  case usersLikesSpecificPost
  case checkToken
  case likePost(postID: PostEncodableRequest)
  case unlikePost(postID: PostEncodableRequest)
  case signOut

  func getRequest(for serverLocation: HostLocation, usingURL url: URLBuilder) -> URLRequest {
    var request = URLRequest(url: url.getURL(mode: serverLocation))
    request.setToGetMethod()
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(token.token, forHTTPHeaderField: "token")
    switch self {
    case .signIn(payload: let signInEncodable):
      request.setToPostMethod()
      request.injectBodyPayload(payload: signInEncodable)
    case .follow(userID: let userEncodableId):
      request.setToPostMethod()
      request.injectBodyPayload(payload: userEncodableId)
    case .unfollow(userID: let userEncodableId):
      request.setToPostMethod()
      request.injectBodyPayload(payload: userEncodableId)
    case .uploadPost(post: let encodableNewPost):
      request.setToPostMethod()
      request.injectBodyPayload(payload: encodableNewPost)
    case .likePost(postID: let postIdEncodable):
      request.setToPostMethod()
      request.injectBodyPayload(payload: postIdEncodable)
    case .unlikePost(postID: let postIdEncodable):
      request.setToPostMethod()
      request.injectBodyPayload(payload: postIdEncodable)
    case .signOut:
      request.setToPostMethod()
    default:
      return request
    }
    return request
  }
}
