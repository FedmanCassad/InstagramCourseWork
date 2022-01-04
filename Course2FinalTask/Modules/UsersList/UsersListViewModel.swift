import Foundation

struct UpdateFields {
    let id: String
    let type: UsersListType
}

protocol IUsersListViewModel {

    /// Массив пользователей для отображения в списке.
    var users: Dynamic<[User]> { get set }

    /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
    /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
    var error: Dynamic<ErrorHandlingDomain?> { get set }

    /// Количество строк в таблице - количество публикаций, нужен для ясности.
    var numberOfRows: Int { get }

    /// Инициализатор
    /// - Parameters:
    ///   - users: модель инициализируется массивом пользователей.
    ///   - updateData: модель данных необходимых для своевременного апдейта списка пользователей. Например после
    ///   подписки/отписки на пользователя.
    init(with users: [User], updateData: UpdateFields?)

    /// Используется для инициализации модели ячейки в tableView.dequeueReusableCell(at:)
    /// - Parameter indexPath: указатель на нужную ячейку.
    func getCellViewModel(atIndexPath indexPath: IndexPath) -> IUsersListCellViewModel

    /// В случае если updateData в наличии(не список лайкнувших), то обновленный список юзеров будет запрошен.
    func updateTableViewIfNeeded()

    /// При тапе на пользователе из списка возвращается модель профиля пользователя для дальнейшей инициализации
    /// и отображения ProfileViewController
    /// - Parameter indexPath: указатель на ячейку из модели которой дергать пользователя.
    func getProfileViewModel(forUserAt indexPath: IndexPath) -> IProfileViewModel
}

final class UsersListViewModel: IUsersListViewModel {

    // MARK: - Props
    var users: Dynamic<[User]>
    var error: Dynamic<ErrorHandlingDomain?>
    lazy var updateHandler: UsersResult = { userResult in
            switch userResult {
            case let .failure(error):
                self.error.value = error
            case let .success(users):
                self.users.value = users
            }
        }

    var isFirstRun: Bool = true
    var numberOfRows: Int {
        users.value.count
    }

    var updateData: UpdateFields?

    let provider: IDataProviderFacade = DataProviderFacade.shared
    // MARK: - Init
    init(with users: [User], updateData: UpdateFields? = nil) {
        self.users = Dynamic(users)
        self.error = Dynamic(nil)
        self.updateData = updateData
    }

    // MARK: - Methods
    func getCellViewModel(atIndexPath indexPath: IndexPath) -> IUsersListCellViewModel {
        return UsersListCellViewModel(with: users.value[indexPath.row])
    }

    func updateTableViewIfNeeded () {
        guard !isFirstRun else {
            isFirstRun = false
            return
        }
        guard let updateData = updateData else {
            return
        }
        updateData.type == .followers
        ? provider.usersFollowingUser(by: updateData.id, handler: updateHandler)
        : provider.usersFollowedByUser(by: updateData.id, handler: updateHandler)
    }

    func getProfileViewModel(forUserAt indexPath: IndexPath) -> IProfileViewModel {
        ProfileViewModel(user: users.value[indexPath.row])
    }
}
