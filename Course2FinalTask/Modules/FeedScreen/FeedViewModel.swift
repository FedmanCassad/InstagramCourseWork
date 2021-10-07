//
//  FeedViewModel.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 03.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
typealias FeedDataSource = UITableViewDiffableDataSource<Int, Post>
typealias FeedSnapshot = NSDiffableDataSourceSnapshot<Int, Post>

protocol IFeedViewModel {
  var error: Dynamic<ErrorHandlingDomain?> { get }
  var updateCellViewModel: ((Int) -> Void)? { get set }
  var authorTapped: ((_ profile: IProfileViewModel) -> Void)? { get set }
  var moveToUsersList: (([User]) -> Void)? { get set }
  var likeTapped: (() -> Void)? { get set }
  var posts: [Post] { get set }
  var rowsCount: Int { get }
  var dataSource: FeedDataSource? { get set }
  func requestFeedPosts(optionalHandler: PostsResult?)
  func updateFeedPost(with post: Post)
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
  var likeTapped: (() -> Void)?
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
        applySnapshot(snapshot: snapshot, animating: true)
      }
    }
  }

  var rowsCount: Int {
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
