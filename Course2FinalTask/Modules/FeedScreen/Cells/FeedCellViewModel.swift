//
//  FeedCellViewModel.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 04.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

protocol IFeedCellViewModel: AnyObject, ImageDataSavingAgent {
  var id: String { get }
  var postDescription: String { get }
  var author: String { get }
  var authorUsername: String { get }
  var createdTime: String { get }
  var likesDataUpdatedAnimation: (() -> Void)? { get set }
  var authorAvatarURL: URL { get }
  var imageURL: URL { get }
  var currentUserLikesThisPost: Bool { get }
  var likedByCount: String { get }
  var eventHandler: IFeedCellEventHandler? { get set }
  var post: Post { get set }
  var error: Dynamic<ErrorHandlingDomain>? { get set }
  func likeTapped() -> Void
  func authorTapped() -> Void
  var postImageData: Data? { get }
  var avatarImageData: Data? { get }
  func likesCountTapped() -> Void
  init(with post: Post)
}



final class FeedCellViewModel: IFeedCellViewModel {

  var error: Dynamic<ErrorHandlingDomain>?
  var eventHandler: IFeedCellEventHandler?
  let dataProvider = DataProviderFacade.shared
  var likesDataUpdatedAnimation: (() -> Void)?
  var post: Post
  init (with post: Post) {
    if dataProvider.location == .LANIP {
      let tempPost = post
      //MARK: !!! TEMPORARY FOR REAL DEVICE TESTING !!!
      tempPost.image = URL(string: tempPost.image.absoluteString.replacingOccurrences(of: "http://localhost:8080", with: dataProvider.location.serverURL.absoluteString))!
      tempPost.authorAvatar = URL(string: tempPost.authorAvatar.absoluteString.replacingOccurrences(of: "http://localhost:8080", with: dataProvider.location.serverURL.absoluteString))!
      self.post = tempPost
    } else {
      self.post = post
    }
    setupSavingBinding()
  }
  
  var id: String {
    post.id
  }
  
  var postDescription: String {
    post.postDescription
  }
  
  var author: String {
    post.author
  }
  
  var authorUsername: String {
    post.authorUsername
  }
  
  var authorAvatarURL: URL {
    post.authorAvatar
  }
  
  var imageURL: URL {
    post.image
  }
  
  var postImageData: Data? {
    post.imageData
  }
  
  var avatarImageData: Data? {
    post.avatarImageData
  }
  
  var createdTime: String {
    let formatter = DateFormatter()
    return formatter.convertToString(date: post.createdTime)
  }
  
  var currentUserLikesThisPost: Bool {
    post.currentUserLikesThisPost
  }
  
  var likedByCount: String {
    "Likes: " + String(post.likedByCount)
  }

  func likesCountTapped() {
    dataProvider.usersLikedSpecificPost(by: id) { [unowned self] result in
      switch result {
        case .failure(let error):
          eventHandler?.passAlert(error: error)
        case .success(let users):
          eventHandler?.likesCountTapped(andReceived: users)
      }
    }
  }
  
  func authorTapped() {
    dataProvider.getUser(by: post.author) {[unowned self] result in
      switch result {
        case let .failure(error):
          eventHandler?.passAlert(error: error)
        case let .success(user):
          eventHandler?.authorTapped(by: user)
      }
    }
  }

  
  private func setupSavingBinding() {
    post.performSaving = {[weak self] post in
      self?.dataProvider.savePost(post: post as! Post)
    }
  }
  
  func likeTapped() {
    _ = currentUserLikesThisPost
      ? eventHandler?.unlikePost(by: self.id, animatingCompletion: likesDataUpdatedAnimation)
      : eventHandler?.likePost(by: self.id, animatingCompletion: likesDataUpdatedAnimation)
  }

  func saveAvatarData(data: Data) {
    post.avatarImageData = data
  }

  func savePostImageData(data: Data) {
    post.imageData = data
  }
}
