import Foundation

protocol IFeedCellViewModel: AnyObject, ImageDataSavingAgent {
  
  /// ID публикации.
  var id: String { get }

  /// Строка описания публикации.
  var postDescription: String { get }

  /// ID автора публикации.
  var author: String { get }

  /// Имя пользователя автора публикации.
  var authorUsername: String { get }

  /// Время создания публикации.
  var createdTime: String { get }

  /// Ссылка на аватар автора.
  var authorAvatarURL: URL { get }

  /// Ссылка на картинку поста.
  var imageURL: URL { get }

  /// Нравится ли текущему пользователю этот пост true: да, false: нет.
  var currentUserLikesThisPost: Bool { get }

  /// Количество лайков публикации.
  var likedByCount: String { get }

  /// Сырые данные картинки поста, нужны для сохранение в оффлайн хранилище.
  var postImageData: Data? { get }

  /// Сырые данные аватарки автора поста, нужны для сохранение в оффлайн хранилище.
  var avatarImageData: Data? { get }

  /// Объект самой публикации.
  var post: Post { get set }

  /// Обычно родительская viewModel - нужен для проброса ошибок и реализации функций лайк/дизлайк,
  /// так как требуется обновить и пост с которым проведена манипуляция, и красиво отобразить эти изменения, что не
  /// получится в одной лишь связке UITableViewCell - TableViewCellViewModel.
  var eventHandler: IFeedCellEventHandler? { get set }

  /// Замыкание в котором контроллер должен передать анимации в случае апдейта данных поста.
  var likesDataUpdatedAnimation: (() -> Void)? { get set }

  /// Срабатывает по касанию лайка либо двойного касания по картинке поста.
  func likeTapped()

  /// Срабатывает при нажатии на аватарку автора или его имя. Получает автора по запрошенному id и передает вью модели
  /// контроллера для дальнейшей инициализации перехода на профиль пользователя.
  func authorTapped()

  /// Вызывается при нажатии на кнопку количества лайков, загружается список пользователей которым нравится эта
  ///  публикация и передается вью модели контроллера для последующего отображения.
  func likesCountTapped()

  /// Иницилизатор
  /// - Parameter post: инициализируется объектом типа Post.
  init(with post: Post)
}

final class FeedCellViewModel: IFeedCellViewModel {

  var eventHandler: IFeedCellEventHandler?
  let dataProvider = DataProviderFacade.shared
  var likesDataUpdatedAnimation: (() -> Void)?
  var post: Post
  init (with post: Post) {
    if dataProvider.location == .LANIP {
      let tempPost = post
      // MARK: - !!! TEMPORARY FOR REAL DEVICE TESTING !!!
      tempPost.image = URL(
        string: tempPost.image.absoluteString.replacingOccurrences(
          of: "http://localhost:8080",
          with: dataProvider.location.serverURL.absoluteString
        )
      )!
      tempPost.authorAvatar = URL(
        string: tempPost.authorAvatar.absoluteString.replacingOccurrences(
          of: "http://localhost:8080",
          with: dataProvider.location.serverURL.absoluteString
        )
      )!
      self.post = tempPost
    } else {
      self.post = post
    }
    setupSavingBinding()
  }

  var id: String {
    post.id
  }

  var postDescription: String {
    post.postDescription
  }

  var author: String {
    post.author
  }

  var authorUsername: String {
    post.authorUsername
  }

  var authorAvatarURL: URL {
    post.authorAvatar
  }

  var imageURL: URL {
    post.image
  }

  var postImageData: Data? {
    post.imageData
  }

  var avatarImageData: Data? {
    post.avatarImageData
  }

  var createdTime: String {
    let formatter = DateFormatter()
    return formatter.convertToString(date: post.createdTime)
  }

  var currentUserLikesThisPost: Bool {
    post.currentUserLikesThisPost
  }

  var likedByCount: String {
    L.likesCountLabel() + String(post.likedByCount)
  }

  func likesCountTapped() {
    dataProvider.usersLikedSpecificPost(by: id) { [unowned self] result in
      switch result {
      case .failure(let error):
          eventHandler?.passAlert(error: error)
      case .success(let users):
          eventHandler?.likesCountTapped(andReceived: users)
      }
    }
  }

  func authorTapped() {
    dataProvider.getUser(by: post.author) {[unowned self] result in
      switch result {
      case let .failure(error):
          eventHandler?.passAlert(error: error)
      case let .success(user):
          eventHandler?.authorTapped(by: user)
      }
    }
  }
  // swiftlint:disable force_cast
  private func setupSavingBinding() {
    post.performSaving = {[weak self] post in
      self?.dataProvider.savePost(post: post as! Post)
    }
  }

  func likeTapped() {
    _ = currentUserLikesThisPost
      ? eventHandler?.unlikePost(by: self.id, animatingCompletion: likesDataUpdatedAnimation)
      : eventHandler?.likePost(by: self.id, animatingCompletion: likesDataUpdatedAnimation)
  }

  func saveAvatarData(data: Data) {
    post.avatarImageData = data
  }

  func savePostImageData(data: Data) {
    post.imageData = data
  }
}
