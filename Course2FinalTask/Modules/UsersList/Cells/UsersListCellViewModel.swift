import Foundation

protocol IUsersListCellViewModel: AnyObject {

  /// Объект пользователя, завернут в Dynamic ради интереса, да и показалось так проще связать с UI элементами.
  var user: Dynamic<User> { get set }

  /// Делегат для отслеживания тапа по ячейке.
  var delegate: UsersListCellDelegate? { get set }

  /// Инициализатор
  /// - Parameter user: модель инициализируется объектом типа User.
  init(with user: User)

  /// Функция срабатывающая по тапу на ячейку(точнее на аватар) и уведомляющая делегата об этом.
  func userCellSelected()
}

class UsersListCellViewModel: IUsersListCellViewModel {
  var user: Dynamic<User>
  weak var delegate: UsersListCellDelegate?

  required init(with user: User) {
    self.user = Dynamic(user)
  }

  func userCellSelected() {
    delegate?.profileCellTapped(by: user.value)
  }
}
