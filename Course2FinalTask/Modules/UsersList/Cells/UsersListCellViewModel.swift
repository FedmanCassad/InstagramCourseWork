import Foundation

protocol IUsersListCellViewModel: AnyObject {
  var user: Dynamic<User> { get set }
  var delegate: UsersListCellDelegate? { get set }
  init(with user: User)
  func userCellSelected() -> Void
}

class UsersListCellViewModel: IUsersListCellViewModel {

  var user: Dynamic<User>
  var delegate: UsersListCellDelegate?

  required init(with user: User) {
    self.user = Dynamic(user)
  }

  func userCellSelected() {
    delegate?.profileCellTapped(by: user.value)
  }

}
