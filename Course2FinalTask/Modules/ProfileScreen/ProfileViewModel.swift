//
//  ProfileViewModel.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 04.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit

protocol IProfileViewModel {
  var user: Dynamic<User?> { get }
  var posts: Dynamic<[Post]>? { get set }
  var error: Dynamic<ErrorHandlingDomain>? { get set }
  func performPostsRequest(with handler: @escaping() -> Void)
  func receiveURLForSpecificIndexPath(for indexPath: IndexPath) -> URL?
}

final class ProfileViewModel: IProfileViewModel {
  var error: Dynamic<ErrorHandlingDomain>?

  let dataProvider: IDataProviderFacade = DataProviderFacade.shared

  var posts: Dynamic<[Post]>?
  var user: Dynamic<User?>

  init(user: User? = DataProviderFacade.shared.currentUser) {
    self.user = Dynamic(user)
  }

  func performPostsRequest(with handler: @escaping() -> Void) {
    guard let user = user.value else {
      return
    }

    dataProvider.findPosts(by: user.id) {[weak self] result in
      switch result {
      case let .failure(error):
        self?.error = Dynamic(error)
      case let .success(posts):
        self?.posts = Dynamic(posts)
        handler()
      }
    }
  }

  func receiveURLForSpecificIndexPath(for indexPath: IndexPath) -> URL? {
    guard let posts = posts?.value else {
      return nil
    }
    return posts[indexPath.item].image
  }

}
