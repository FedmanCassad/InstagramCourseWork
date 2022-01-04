import UIKit

public enum Mode {
  case offline, online
}

protocol IDataProviderFacade: ILoginFlow {
  var mode: Mode { get }
  var currentUser: User? { get set }
  /// Установка состояния онлайн-статуса.
  func setOffline()

  /// Установка состояния онлайн-статуса.
  func setOnline()

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

  /// Получение публикаций ленты.
  /// - Parameter completion: Замыкание, в которое возвращаются запрашиваемые публикации.
  ///   Вызывается после выполнения запроса.
  func getFeed(handler: @escaping PostsResult)

  /// Лайк поста по указанному ID.
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

  /// Сохранение поста
  func savePost(post: Post)

  /// Сохранение юзера
  func saveUser(user: User)
}

final class DataProviderFacade: IDataProviderFacade {
  var mode: Mode = .online
  var location: HostLocation {
    onlineProvider.location
  }
  var window: UIWindow? {
    UIApplication.shared.windows.first
  }
  static let shared = DataProviderFacade()
  let onlineProvider: INetworkEngine = NetworkEngine.shared
  let offlineProvider: IPersistentDataProvider! = PersistentDataProvider.shared

  lazy var currentUser: User? = nil {
    didSet {
      currentUser?.performSaving = {[weak self] user in
        guard let user = user as? User else { return }
        self?.offlineProvider.saveCurrentUserID(with: user.id)
        self?.offlineProvider.saveUserToPersistentStore(user: user)
      }
      guard var avatarURL = currentUser?.avatar else { return }
      guard mode == .online else { return }
      if onlineProvider.location == .LANIP {
        avatarURL = URL(
          string: avatarURL.absoluteString.replacingOccurrences(
            of: "http://localhost:8080",
            with: NetworkEngine.shared.location.serverURL.absoluteString
          )
        )!
      }
      URLSession(configuration: .default).dataTask(with: avatarURL) {data, _, error in
        if let error = error {
          debugPrint(error.localizedDescription)
        }
        guard let data = data else { return }
        self.currentUser?.avatarData = data
      }.resume()
    }
  }

  func setOffline() {
    mode = .offline
  }

  func setOnline() {
    mode = .online
  }

  private init() {}

  func getCurrentUser(handler: @escaping UserResult) {
    LockingView.lock()
    if mode == .online {
      onlineProvider.getCurrentUser {[unowned self] result in
        switch result {
        case let .failure(error):
          handler(.failure(error))
        case let .success(user):
          currentUser = user
          handler(.success(user))
        }
      }
    } else {
      guard let currentUser = offlineProvider.getCurrentUserFromPersistentStore(),
            let normalUser = User(from: currentUser)
      else {
        handler(.failure(.noDataReceived))
        return
      }
      handler(.success(normalUser))
    }
  }

  func getUser(by userID: User.ID, handler: @escaping UserResult) {
    LockingView.lock()
    if mode == .online {
      onlineProvider.getUser(by: userID, handler: handler)
    } else {
      guard let user = offlineProvider.getSpecificUser(by: userID) else {
        handler(.failure(.noUserStored))
        return
      }
      handler(.success(user))
    }
  }

  func follow(by userID: User.ID, handler: @escaping UserResult) {
    LockingView.lock()
    guard mode == .online else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.follow(by: userID, handler: handler)
  }

  func unfollow(by userID: User.ID, handler: @escaping UserResult) {
    LockingView.lock()
    guard mode == .online else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.unfollow(by: userID, handler: handler)
  }

  func usersFollowingUser(by userID: User.ID, handler: @escaping UsersResult) {
    LockingView.lock()
    guard mode == .online else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.usersFollowingUser(by: userID, handler: handler)
  }

  func usersFollowedByUser(by userID: User.ID, handler: @escaping UsersResult) {
    LockingView.lock()
    guard mode == .online else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.usersFollowedByUser(by: userID, handler: handler)
  }

  func findPosts(by userID: User.ID, handler: @escaping PostsResult) {
    LockingView.lock()
    if mode == .online {
      onlineProvider.findPosts(by: userID, handler: handler)
    } else {
      let posts = offlineProvider.getSpecificPostsFromPersistentStore(by: ["author": userID])
      guard !posts.isEmpty else {
        handler(.failure(.noDataReceived))
        return
      }
      handler(.success(posts.compactMap { Post(from: $0) }))
    }
  }

  func getFeed(handler: @escaping PostsResult) {
    LockingView.lock()
    if mode == .online {
      onlineProvider.getFeed {result in
        switch result {
        case .failure(let error):
          handler(.failure(error))
        case .success(let posts):
          handler(.success(posts))
        }
      }
    } else {
      let posts = offlineProvider.getFeedFromPersistentStore()
      if !posts.isEmpty {
        handler(.success(posts))
      } else {
        handler(.failure(.noDataReceived))
      }
    }
  }

  func likePost(by postID: Post.ID, handler: @escaping PostResult) {
    guard mode == .online else {
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.likePost(by: postID, handler: handler)
  }

  func unlikePost(by postID: Post.ID, handler: @escaping PostResult) {
    guard mode == .online else {
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.unlikePost(by: postID, handler: handler)
  }

  func usersLikedSpecificPost(by postID: Post.ID, handler: @escaping UsersResult) {
    LockingView.lock()
    guard mode == .online else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.usersLikedSpecificPost(by: postID, handler: handler)
  }

  func uploadPost(image: Data?, description: String, handler: @escaping PostResult) {
    LockingView.lock()
    guard mode == .online else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
      return
    }
    onlineProvider.uploadPost(image: image, description: description, handler: handler)
  }

  func saveUser(user: User) {
    offlineProvider.saveUserToPersistentStore(user: user)
  }

  func savePost(post: Post) {
    offlineProvider.savePost(post: post)
  }
}

extension DataProviderFacade: ILoginFlow {

  func loginToServer(signInModel: SignInModel, handler: @escaping TokenResult) {
    LockingView.lock()
    if mode == .online {
      onlineProvider.loginToServer(signInModel: signInModel, handler: handler)
    } else {
      if let token = KeychainService.getToken() {
        handler(.success(TokenModel(token: token)))
      }
    }
  }

  func checkToken(handler: @escaping EmptyResult) {
    LockingView.lock()
    onlineProvider.checkToken {result in
      switch result {
      case .success:
        handler(.success(()))
      case .failure(let error):
        switch error {
        case let .requestError(errorCode: response):
          if response.statusCode == 401 {
            handler(.failure(.tokenExpired))
          }
        default:
          handler(.failure(.serverUnreachable))
        }
      }
    }
  }

  func logOut(handler: @escaping EmptyResult) {
    if mode == .online {
      KeychainService.deleteToken()
      offlineProvider.deleteAllPostsFromPersistentStore()
      offlineProvider.deleteAllUsersFromPersistentStore()
      onlineProvider.logOut(handler: handler)
    } else {
      LockingView.unlock()
      handler(.failure(.unavailableInOfflineMode))
    }
  }
}
