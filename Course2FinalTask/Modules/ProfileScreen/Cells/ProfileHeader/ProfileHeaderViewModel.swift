import Foundation

protocol IProfileHeaderViewModel: AnyObject, ImageDataSavingAgent {

  /// Объект User обернутый в Dynamic, при получении value в listener'е происходит конфигурирование UI элементов.
  var user: Dynamic<User> { get }

  /// В зависимости от значение добавляется кнопка Logout или Follow/Unfollow.
  var isCurrentUser: Dynamic<Bool> { get set }

  /// Если приходит true, значит подчищены все данные,token инвалидирован, приложение переходит в initial state.
  var logoutSuccess: Dynamic<Bool>? { get set }

  /// Текст количества подписчиков. Локализован.
  var followersText: String { get }

  /// Текст количества подписок. Локализован.
  var followingsText: String { get }

  /// Сырые данные для кэширования в оффлайн хранилище.
  var avatarImageData: Data? { get }

  /// Текст кнопки подписки/отписки. Локализован.
  var followOrUnfollowButtonTitle: String { get }

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get set }

  /// Замыкание в которое приходит массив юзеров. Этот массив прокидывается модели контроллера для последующей
  /// инициализации и отображения UserListViewController.
  var followersOrFollowsListUsers: (([User]) -> Void)? { get set }

  /// При нажатии на кнопку logOut обращается к провайдеру DataProvidingFacade который делает всю работу.
  func logOut()

  /// Реализуется функционал проставления лайка/дизлайка.
  func followOrUnfollowButtonTapped()

  /// Запрашивает список пользователей
  /// - Parameter type: в зависимости от параметра запрашиваются либо подписки либо подписчики.
  func usersListRequested(by type: UsersListType)
}

final class ProfileHeaderViewModel: IProfileHeaderViewModel {

  var followersOrFollowsListUsers: (([User]) -> Void)?
  var user: Dynamic<User>
  var isCurrentUser: Dynamic<Bool>
  var logoutSuccess: Dynamic<Bool>?
  var error: Dynamic<ErrorHandlingDomain?>

  var followersText: String {
    R.string.localizable.followersLabelTitle() + String(user.value.followedByCount)
  }

  var followingsText: String {
    R.string.localizable.followedLabelTitle() + String(user.value.followsCount)
  }

  var avatarImageData: Data? {
    user.value.avatarData
  }

  var followOrUnfollowButtonTitle: String {
    let title = user.value.currentUserFollowsThisUser
      ? R.string.localizable.unfollowButtonTitle()
      : R.string.localizable.followButtonTitle()
    return title
  }

  private var provider: IDataProviderFacade = DataProviderFacade.shared

  init(user: User? = DataProviderFacade.shared.currentUser) {
    self.user = Dynamic(user!)
    self.logoutSuccess = Dynamic(false)
    self.error = Dynamic(nil)
    isCurrentUser = Dynamic(user?.id == DataProviderFacade.shared.currentUser?.id)
    setupSavingBinding()
  }

  func logOut() {
    provider.logOut {[weak self] result in
      switch result {
      case let .failure(error):
        self?.error.value = error
      case .success:
        self?.logoutSuccess?.value = true
      }
    }
  }

  func followOrUnfollowButtonTapped() {
    let updateHandler: UserResult = {[unowned self] result in
      switch result {
      case let .failure(error):
        self.error.value = error
      case let .success(user):
        self.user.value = user
      }
    }

    if user.value.currentUserFollowsThisUser {
      provider.unfollow(by: user.value.id, handler: updateHandler)
    } else {
      provider.follow(by: user.value.id, handler: updateHandler)
    }
  }

  func usersListRequested(by type: UsersListType) {
    let usersListHandler: UsersResult = {[unowned self] result in
      switch result {
      case let .failure(error):
        self.error.value = error
      case let .success(users):
        followersOrFollowsListUsers?(users)
      }
    }
    if type == .followers {
      provider.usersFollowingUser(by: user.value.id, handler: usersListHandler )
    } else if type == .followings {
      provider.usersFollowedByUser(by: user.value.id, handler: usersListHandler)
    }
  }

  func saveAvatarData(data: Data) {
    user.value.avatarData = data
  }
  private func setupSavingBinding() {
    user.value.performSaving = {[weak self] user in
      guard let user = user as? User else { return }
      self?.provider.saveUser(user: user)
    }
  }

  func savePostImageData(data: Data) {}

}
