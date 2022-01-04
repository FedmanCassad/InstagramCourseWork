import UIKit
typealias FeedDataSource = UITableViewDiffableDataSource<Int, Post>
typealias FeedSnapshot = NSDiffableDataSourceSnapshot<Int, Post>

protocol IFeedViewModel {

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get }

  /// Массив публикаций.
  var posts: [Post] { get set }

  /// Количество строк в таблице - количество публикаций, нужен для ясности.
  var numberOfRows: Int { get }

  /// Данные для отображения в таблице берутся здесь. Используется DiffableDataSource, новая удобная технология.
  var dataSource: FeedDataSource? { get set }

  /// После всех подкапотных манипуляций сюда прилетает вью модель пользователя для инициализации
  /// ProfileViewController'а и последующему переходу к нему.
  var authorTapped: ((_ profile: IProfileViewModel) -> Void)? { get set }

  /// Используется непосредственно для обновления поста в модель ячейки. Передается номер ячейки.
  var updateCellViewModel: ((Int) -> Void)? { get set }

  /// Сюда прилетает массив пользователей для дальнейшего отображения их в виде списка.
    var moveToUsersList: (([User]) -> Void)? { get set }

  /// Запрос массива публикаций
  /// - Parameter optionalHandler: опциональный хендлер нужен для реализации unit теста.
  func requestFeedPosts(optionalHandler: PostsResult?)

  /// Заменяет в массиве публикаций пост на обновленный пост по его id. И затем вызывает updateCellViewModel, который
  /// достается через контроллер, который дергает нужную ячейку и её модель через tableView.cellForRow(at:)
  /// - Parameter post: пост на замену.
  func updateFeedPost(with post: Post)

  /// Используется в tableView.dequeueReusableCell для более удобной инициализации модели ячейки.
  func constructFeedCellViewModel(at indexPath: IndexPath) -> IFeedCellViewModel
}

protocol IFeedCellEventHandler {
  func likePost(by postID: String, animatingCompletion: (() -> Void)?)
  func unlikePost(by postID: String, animatingCompletion:  (() -> Void)?)
  func authorTapped(by user: User)
  func likesCountTapped(andReceived users: [User])
  func passAlert(error: ErrorHandlingDomain)
}

final class FeedViewModel: IFeedViewModel {

  // MARK: - Props
  var error: Dynamic<ErrorHandlingDomain?> = Dynamic(nil)
  var authorTapped: ((IProfileViewModel) -> Void)?
var moveToUsersList: (([User]) -> Void)?
  var updateCellViewModel: ((Int) -> Void)?
  let dataProvider: IDataProviderFacade = DataProviderFacade.shared
  var dataSource: FeedDataSource?
  var posts: [Post] = [Post]() {
    didSet {
      let oldCount = oldValue.count
      let newCount = posts.count
      if oldCount != newCount {
        var snapshot = FeedSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        applySnapshot(snapshot: snapshot, animating: false)
      }
    }
  }

  var numberOfRows: Int {
    posts.count
  }

  // MARK: - Methods
  func requestFeedPosts(optionalHandler: PostsResult? = nil) {
    dataProvider.getFeed {result in
      switch result {
      case let .failure(error):
          self.error.value = error
        optionalHandler?(.failure(error))
      case let .success(feed):
          self.posts = feed
        optionalHandler?(.success(feed))
      }
    }
  }

  func updateFeedPost(with post: Post) {
    guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
    posts[index] = post
    updateCellViewModel?(index)
  }

  func applySnapshot(snapshot: FeedSnapshot, animating: Bool = true) {
    dataSource?.apply(snapshot, animatingDifferences: animating)
  }

  func constructFeedCellViewModel(at indexPath: IndexPath) -> IFeedCellViewModel {
    FeedCellViewModel(with: posts[indexPath.row])
  }
}

// MARK: - Cell's delegate methods
extension FeedViewModel: IFeedCellEventHandler {

  func likesCountTapped(andReceived users: [User]) {
    moveToUsersList?(users)
  }

  func authorTapped(by user: User) {
    let profileViewModel = ProfileViewModel(user: user)
    authorTapped?(profileViewModel)
  }

  func unlikePost(by postID: String, animatingCompletion: (() -> Void)?) {
    dataProvider.unlikePost(by: postID) {result in
      switch result {
      case .success(let post):
          self.updateFeedPost(with: post)
          DispatchQueue.main.async {
            animatingCompletion?()
          }
      case .failure(let error):
          self.error.value = error
      }
    }
  }

  func passAlert(error: ErrorHandlingDomain) {
    self.error.value = error
  }

  func likePost(by postID: Post.ID, animatingCompletion: (() -> Void)?) {
    dataProvider.likePost(by: postID) {result in
      switch result {
      case .success(let post):
          self.updateFeedPost(with: post)
          DispatchQueue.main.async {
            animatingCompletion?()
          }
      case .failure(let error):
          self.error.value = error
      }
    }
  }
}
