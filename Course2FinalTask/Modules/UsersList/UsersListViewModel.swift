import Foundation

protocol IUsersListViewModel {
  var users: [User] { get set }
  var error: Dynamic<ErrorHandlingDomain?> { get set }
  var numberOfRows: Int { get }
  init(with users: [User])
  func getCellViewModel(atIndexPath indexPath: IndexPath) -> IUsersListCellViewModel
  func getProfileViewModel(forUserAt indexPath: IndexPath) -> IProfileViewModel
}

final class UsersListViewModel: IUsersListViewModel {

  //MARK: - Props
  var users: [User]
  var error: Dynamic<ErrorHandlingDomain?>

  var numberOfRows: Int {
    users.count
  }

  //MARK: - Init
 init(with users: [User]) {
    self.users = users
    self.error = Dynamic(nil)
  }

  //MARK: - Methods
  //Methods used to construct cell's view model in tableView(_..., cellForRowAt indexPath: IndexPath)
  func getCellViewModel(atIndexPath indexPath: IndexPath) -> IUsersListCellViewModel {
    return UsersListCellViewModel(with: users[indexPath.row])
  }

  func getProfileViewModel(forUserAt indexPath: IndexPath) -> IProfileViewModel {
    ProfileViewModel(user: users[indexPath.row])
  }

}
