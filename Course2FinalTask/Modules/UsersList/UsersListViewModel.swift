import Foundation

protocol IUsersListViewModel {

  /// Массив пользователей для отображения в списке.
  var users: [User] { get set }

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get set }

  /// Количество строк в таблице - количество публикаций, нужен для ясности.
  var numberOfRows: Int { get }

  /// Инициализатор
  /// - Parameter users: модель инициализируется массивом пользователей.
  init(with users: [User])

  /// Используется для инициализации модели ячейки в tableView.dequeueReusableCell(at:)
  /// - Parameter indexPath: указатель на нужную ячейку.
  func getCellViewModel(atIndexPath indexPath: IndexPath) -> IUsersListCellViewModel

  /// При тапе на пользователе из списка возвращается модель профиля пользователя для дальнейшей инициализации
  /// и отображения ProfileViewController
  /// - Parameter indexPath: указатель на ячейку из модели которой дергать пользователя.
  func getProfileViewModel(forUserAt indexPath: IndexPath) -> IProfileViewModel
}

final class UsersListViewModel: IUsersListViewModel {

  // MARK: - Props
  var users: [User]
  var error: Dynamic<ErrorHandlingDomain?>

  var numberOfRows: Int {
    users.count
  }

  // MARK: - Init
 init(with users: [User]) {
    self.users = users
    self.error = Dynamic(nil)
  }

  // MARK: - Methods
  func getCellViewModel(atIndexPath indexPath: IndexPath) -> IUsersListCellViewModel {
    return UsersListCellViewModel(with: users[indexPath.row])
  }

  func getProfileViewModel(forUserAt indexPath: IndexPath) -> IProfileViewModel {
    ProfileViewModel(user: users[indexPath.row])
  }
}
