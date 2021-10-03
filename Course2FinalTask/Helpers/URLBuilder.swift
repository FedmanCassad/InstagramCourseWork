//
//  URlGenerator.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 30.05.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

enum URLBuilder {

  case signIn
  case feed
  case getCurrentUser
  case findPosts(userID: User.ID)
  case userFollowers(userID: User.ID)
  case userFollowing(userID: User.ID)
  case follow
  case unfollow
  case getUser(userID: User.ID)
  case uploadPost
  case usersLikesSpecificPost(postID: Post.ID)
  case likePost
  case unlikePost
  case checkToken
  case signOut

  func getURL(mode: HostLocation) -> URL {
    var appendingPath: String
    switch self {
    case .signIn:
      appendingPath = "/signin"
    case .feed:
      appendingPath = "/posts/feed"
    case .getCurrentUser:
      appendingPath = "/users/me"
    case let .findPosts(userID: userID):
      appendingPath = "/users/\(userID)/posts"
    case let .userFollowers(userID: userID):
      appendingPath = "/users/\(userID)/followers"
    case let .userFollowing(userID: userID):
      appendingPath = "/users/\(userID)/following"
    case .follow:
      appendingPath = "/users/follow"
    case .unfollow:
      appendingPath = "/users/unfollow"
    case .uploadPost:
      appendingPath = "/posts/create"
    case let .usersLikesSpecificPost(postID: postID):
      appendingPath = "/posts/\(postID)/likes"
    case .likePost:
      appendingPath = "/posts/like"
    case .unlikePost:
      appendingPath = "/posts/unlike"
      case .checkToken:
        appendingPath = "/checkToken"
    case .signOut:
      appendingPath = "/signout"
    case let .getUser(userID: userID):
      appendingPath = "/users/\(userID)"
    }
    return mode.serverURL.appendingPathComponent(appendingPath)
  }
}
