//
//  ProfileHeaderViewModel.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 08.08.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
public enum UsersListType {
  case followers, followings
}
protocol IProfileHeaderViewModel: AnyObject, ImageDataSavingAgent {
  var user: Dynamic<User> { get }
  var isCurrentUser: Dynamic<Bool> { get set }
  var logoutSuccess: Dynamic<Bool>? { get set }
  var error: Dynamic<ErrorHandlingDomain?> { get set}
  var followersOfFollowsListUsers:(([User]) -> Void)? { get set }
  var followersText: String { get }
  var followingsText: String { get }
  var avatarImageData: Data? { get }
  var followOrUnfollowButtonTitle: String { get }
  func logOut() -> Void
  func followOrUnfollowButtonTapped() -> Void
  func usersListRequested(by type: UsersListType) -> Void

}

final class ProfileHeaderViewModel: IProfileHeaderViewModel {

  var followersOfFollowsListUsers: (([User]) -> Void)?
  var user: Dynamic<User>
  var isCurrentUser: Dynamic<Bool>
  var logoutSuccess: Dynamic<Bool>?
  var error: Dynamic<ErrorHandlingDomain?>

  var followersText: String {
    "Followers: " + String(user.value.followedByCount)
  }

  var followingsText: String {
    "Following: " + String(user.value.followsCount)
  }

  var avatarImageData: Data? {
    user.value.avatarData
  }

  var followOrUnfollowButtonTitle: String {
    let title = user.value.currentUserFollowsThisUser ? "Unfollow" : "Follow"
    return title
  }
  private var provider: IDataProviderFacade = DataProviderFacade.shared

  init(user: User? = NetworkEngine.shared.currentUser) {
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
        case .success():
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
      switch result{
        case let .failure(error):
          self.error.value = error
        case let .success(users):
          followersOfFollowsListUsers?(users)
      }
    }
    if type == .followers {
      provider.usersFollowingUser(by: user.value.id, handler:usersListHandler )
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
