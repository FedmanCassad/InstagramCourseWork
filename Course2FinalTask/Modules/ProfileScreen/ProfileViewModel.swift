import UIKit

protocol IProfileViewModel {

  /// Пользователь для отображения в хедере
  var user: User? { get set }

  /// Массив публикаций пользователя для отображения картинок публикаций в collectionView
  var posts: [Post]? { get set }

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get set }

  /// Здесь запрашивается массив постов созданных пользователем
  /// - Parameter handler: - хендлер нужен для своевременного конфигурирования UI элементов. В противовес Dynamic
  /// обертки для демонстрации.
  func performPostsRequest(with handler: @escaping() -> Void)

  /// Так как для отображения коллекции весь объект типа Post не нужен, поэтому при создании ячейки используется только
  /// url картинки.
  /// - Parameter indexPath: - прописка картинка.
  func receiveURLForSpecificIndexPath(for indexPath: IndexPath) -> URL?
}

final class ProfileViewModel: IProfileViewModel {
  var error: Dynamic<ErrorHandlingDomain?>

  let dataProvider: IDataProviderFacade = DataProviderFacade.shared

  var posts: [Post]?
  var user: User?

  init(user: User? = DataProviderFacade.shared.currentUser) {
    self.user = user
    self.error = Dynamic(nil)
  }

  func performPostsRequest(with handler: @escaping() -> Void) {
    func findPosts(by id: String) {
      dataProvider.findPosts(by: id) {[weak self] result in
        switch result {
        case let .failure(error):
          self?.error = Dynamic(error)
        case let .success(posts):
          self?.posts = posts
          handler()
        }
      }
    }

    guard let user = user else {
      dataProvider.getCurrentUser {[weak self] result in
        switch result {
        case .failure(let error):
          self?.error.value = error
        case .success(let user):
          self?.user = user
          findPosts(by: user.id)
        }
      }
      return
    }
    findPosts(by: user.id)
  }

  func receiveURLForSpecificIndexPath(for indexPath: IndexPath) -> URL? {
    guard let posts = posts else {
      return nil
    }
    return posts[indexPath.item].image
  }
}
