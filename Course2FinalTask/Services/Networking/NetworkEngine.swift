import Foundation

protocol INetworkEngine: ILoginFlow {
  var mode: Mode { get }
  var currentUser: User? { get set }
  var location: HostLocation { get }
  /// Установка состояния онлайн-статуса.
  /// - Parameter status: Новое состояние.
  func setOnlineStatus(to status: Mode)

  /// Получение текущего пользователя.
  /// - Parameter handler: В замыкание приходит или не приходит объект типа User, через объект
  ///   Result<User, ErrorHandlingDomain>
  ///   Вызывается после выполнения запроса.
  func getCurrentUser(handler: @escaping UserResult)

  /// Получение пользователя с указанным ID.
  /// - Parameters:
  ///   - userID: ID пользователя.
  ///   - handler: Замыкание, в которое возвращается запрашиваемый пользователь.
  ///   Вызывается после выполнения запроса.
  func getUser(by userID: User.ID, handler: @escaping UserResult)

  /// Подписывает текущего пользователя на пользователя с указанным ID.
  /// - Parameters:
  ///   - userID: ID пользователя.
  ///   - handler: Замыкание, в которое возвращается пользователь, на которого подписался текущий пользователь.
  ///   Вызывается после выполнения запроса.
  func follow(by userID: User.ID, handler: @escaping UserResult)

  /// Отписывает текущего пользователя от пользователя с указанным ID.
  /// - Parameters:
  ///   - userID: ID пользователя.
  ///   - handler: Замыкание, в которое возвращается пользователь, от которого отписался текущий пользователь.
  ///   Вызывается после выполнения запроса.
  func unfollow(by userID: User.ID, handler: @escaping UserResult)

  /// Получение всех подписчиков пользователя с указанным ID.
  /// - Parameters:
  ///   - userID: ID пользователя.
  ///   - handler: Замыкание, в которое возвращаются запрашиваемые пользователи.
  ///   Вызывается после выполнения запроса.
  func usersFollowingUser(by userID: User.ID, handler: @escaping UsersResult)

  /// Получение всех подписок пользователя с указанным ID.
  /// - Parameters:
  ///   - userID: ID пользователя.
  ///   - handler: Замыкание, в которое возвращаются запрашиваемые пользователи.
  ///   Вызывается после выполнения запроса.
  func usersFollowedByUser(by userID: User.ID, handler: @escaping UsersResult)

  /// Получение публикаций пользователя с указанным ID.
  /// - Parameters:
  ///   - userID: ID пользователя.
  ///   - handler: Замыкание, в которое возвращаются запрашиваемые публикации.
  ///   Вызывается после выполнения запроса.
  func findPosts(by userID: User.ID, handler: @escaping PostsResult)

  /// Получение публикаций пользователей, на которых подписан текущий пользователь.
  /// - Parameter completion: Замыкание, в которое возвращаются запрашиваемые публикации.
  ///   Вызывается после выполнения запроса.
  func getFeed(handler: @escaping PostsResult)

  /// Получение публикации с указанным ID.
  /// - Parameters:
  ///   - postID: ID публикации.
  ///   - handler: Замыкание, в которое возвращается запрашиваемая публикация.
  ///   Вызывается после выполнения запроса.
  func likePost(by postID: Post.ID, handler: @escaping PostResult)

  /// Удаляет лайк от текущего пользователя на публикации с указанным ID.
  /// - Parameters:
  ///   - postID: ID публикации.
  ///   - handler: Замыкание, в которое возвращается публикация, у которой был убран лайк.
  ///   Вызывается после выполнения запроса.
  func unlikePost(by postID: Post.ID, handler: @escaping PostResult)

  /// Получение пользователей, поставивших лайк на публикацию с указанным ID.
  /// - Parameters:
  ///   - postID: ID публикации.
  ///   - handler: Замыкание, в которое возвращаются запрашиваемые пользователи.
  ///   Вызывается после выполнения запроса.
  func usersLikedSpecificPost(by postID: Post.ID, handler: @escaping UsersResult)

  /// Создание новой публикации.
  /// - Parameters:
  ///   - image: Изображение публикации.
  ///   - description: Описание публикации.
  ///   - handler: Замыкание, в которое возвращаются опубликованная публикация.
  ///   Вызывается после выполнения запроса.
  func uploadPost(image: Data?, description: String, handler: @escaping PostResult)
}

protocol ILoginFlow: AnyObject {
  var currentUser: User? { get set }
  /// Создание новой публикации.
  /// - Parameters:
  ///   - signInModel: Изображение публикации.
  ///   - handler: Замыкание, в которое возвращаются опубликованная публикация.
  ///   Вызывается после выполнения запроса.
  func loginToServer(signInModel: SignInModel, handler: @escaping TokenResult)

  /// Запрос авторизации пользователя и получения токена.
  /// - Parameters:
  ///   - handler: В случае если сервер в сети - придет .success пустой, в случае если сервер - оффлайн,
  ///    придет error.
  func checkToken(handler: @escaping (Result<Void, ErrorHandlingDomain>) -> Void)

  /// Запрос авторизации пользователя и получения токена.
  /// - Parameters:
  ///   - handler: В случае если инвалидация токена успешна - придет .success пустой,
  ///   в случае если до сервера достучаться не получилось - придет error, локальная запись токена после этого
  ///   все равно должна быть потерта.
  func logOut(handler: @escaping (Result<Void, ErrorHandlingDomain>) -> Void)

  func getCurrentUser(handler: @escaping UserResult)

  func setOffline()

  /// Установка состояния онлайн-статуса.
  func setOnline()
}

class NetworkEngine: INetworkEngine {

  private(set) var mode: Mode = .online

  func setOnlineStatus(to statusMode: Mode) {
    mode = statusMode
  }

  var currentUser: User?
  var tempUser: User?
  var token: String?
  let session: URLSession = URLSession(configuration: .default)
  private(set) var location: HostLocation = .LANIP

  /// Общий и единственный объект класса
  static var shared: NetworkEngine = {
    NetworkEngine()
  }()

  private init() {}

  // MARK: - Just for fun
  private func runInMainQueue(block: @escaping () -> Void) {
    DispatchQueue.main.async {
      block()
    }
  }

  func setTokenManually(token: String) {
    self.token = token
  }

  private func parseData<T: Decodable>(data: Data) -> T? {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    dateFormatter.locale = Locale.current
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return try? decoder.decode(T.self, from: data)
  }

  private func performRequest<T: Decodable>(request: URLRequest,
                                            completion: @escaping (Result<T, ErrorHandlingDomain>) -> Void) {
    print(request.url!.absoluteString)
    session.dataTask(with: request) {data, _, error in
      if let error = error {
        completion(.failure(.networkError(error: error)))
      }
      if let data = data {
        let value = self.parseData(data: data) as T?
        completion(value != nil ?
                    .success(value!) :
                    .failure(.parsingFailed))
        LockingView.unlock()
      }
    }.resume()
  }

  // MARK: - Loading feed
  func getFeed(handler: @escaping PostsResult) {
    let request = NetworkRequestBuilder.feed.getRequest(for: location, usingURL: .feed)
    performRequest(request: request, completion: handler)
  }

  // MARK: - Loading model of current user
  func getCurrentUser(handler: @escaping (Result<User, ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder.getCurrentUser.getRequest(for: location, usingURL: .getCurrentUser)
    performRequest(request: request, completion: handler)
  }

  // MARK: - Find posts function
  func findPosts(by userID: User.ID, handler: @escaping (Result<[Post], ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder.findPosts.getRequest(for: location, usingURL: .findPosts(userID: userID))
    performRequest(request: request, completion: handler)
  }

  // MARK: - Find followers
  func usersFollowingUser(by userID: User.ID, handler: @escaping (Result<[User], ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .userFollowings
      .getRequest(
        for: location,
        usingURL: .userFollowers(userID: userID)
      )
    performRequest(request: request, completion: handler)
  }

  // MARK: - Find followings
  func usersFollowedByUser(by userID: User.ID, handler: @escaping (Result<[User], ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .userFollowed
      .getRequest(for: location,
                  usingURL: .userFollowing(userID: userID))
    performRequest(request: request, completion: handler)
  }
  // MARK: - Follow function
  func follow(by userID: User.ID, handler: @escaping (Result<User, ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .follow(userID: UserEncodableRequest(userID: userID))
      .getRequest(for: location, usingURL: .follow)
    performRequest(request: request, completion: handler)
  }

  // MARK: - Unfollow function
  func unfollow(by userID: String, handler: @escaping (Result<User, ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .unfollow(userID: UserEncodableRequest(userID: userID))
      .getRequest(for: location, usingURL: .unfollow)
    performRequest(request: request, completion: handler)
  }

  // MARK: - Upload post
  func uploadPost(image: Data?, description: String, handler: @escaping (Result<Post, ErrorHandlingDomain>) -> Void) {
    if let base64String = image?.base64EncodedString() {
      let request = NetworkRequestBuilder
        .uploadPost(post: PostUploadingRequest(image: base64String, description: description))
        .getRequest(for: location, usingURL: .uploadPost)
      performRequest(request: request, completion: handler)
    } else {
      handler(.failure(.imageDataConvertingError))
    }
  }

  // MARK: - Get user by id
  func getUser(by userID: User.ID, handler: @escaping (Result<User, ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder.getUser.getRequest(for: location, usingURL: .getUser(userID: userID))
    performRequest(request: request, completion: handler)
  }

  // MARK: - Get users liked specific post
  func usersLikedSpecificPost(by postID: Post.ID, handler: @escaping (Result<[User], ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .usersLikesSpecificPost
      .getRequest(for: location, usingURL: .usersLikesSpecificPost(postID: postID))
    performRequest(request: request, completion: handler)
  }

  // MARK: - Like post
  func likePost(by postID: Post.ID, handler: @escaping (Result<Post, ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .likePost(postID: PostEncodableRequest(postID: postID))
      .getRequest(for: location, usingURL: .likePost)
    performRequest(request: request, completion: handler)
  }

  // MARK: - Unlike post
  func unlikePost(by postID: Post.ID, handler: @escaping (Result<Post, ErrorHandlingDomain>) -> Void) {
    let request = NetworkRequestBuilder
      .unlikePost(postID: PostEncodableRequest(postID: postID))
      .getRequest(for: location, usingURL: .unlikePost)
    performRequest(request: request, completion: handler)
  }
}

// MARK: - Login flow interface implementation
extension NetworkEngine: ILoginFlow {

  func checkToken(handler: @escaping EmptyResult) {
    let request = NetworkRequestBuilder
      .checkToken
      .getRequest(for: location, usingURL: .checkToken)
    session.dataTask(with: request) {_, response, error in
      if error != nil {
        handler(.failure(.serverUnreachable))
      }
      if let response = response as? HTTPURLResponse {
        switch response.statusCode {
        case 200:
          handler(.success(()))
        case 401:
          handler(.failure(.requestError(errorCode: response)))
        default:
          handler(.failure(.serverUnreachable))
        }
      }
      LockingView.unlock()
    }.resume()
  }

  func logOut(handler: @escaping EmptyResult) {
    let url = URLBuilder.signOut.getURL(mode: location)
    session.dataTask(with: url) {_, _, error in
      guard let error = error else {
        handler(.success(()))
        LockingView.unlock()
        return
      }
      handler(.failure(.networkError(error: error)))
      LockingView.unlock()
    }.resume()
  }

  func loginToServer(signInModel: SignInModel, handler: @escaping TokenResult) {
    let request = NetworkRequestBuilder.signIn(payload: signInModel).getRequest(for: location, usingURL: .signIn)
    performRequest(request: request, completion: handler)
  }

  func setOffline() {
    mode = .offline
  }

  func setOnline() {
    mode = .online
  }

}
