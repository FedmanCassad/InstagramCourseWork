//
//  Types.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 01.10.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
import Kingfisher

typealias UserResult = (Result<User, ErrorHandlingDomain>) -> Void
typealias UsersResult = (Result<[User], ErrorHandlingDomain>) -> Void
typealias PostResult = (Result<Post, ErrorHandlingDomain>) -> Void
typealias PostsResult = (Result<[Post], ErrorHandlingDomain>) -> Void
typealias TokenResult = (Result<TokenModel, ErrorHandlingDomain>) -> Void
typealias EmptyResult = (Result<Void, ErrorHandlingDomain>) -> Void
typealias ImageCachingClosure = (Result<RetrieveImageResult, KingfisherError>) -> Void

protocol ImageDataSavingAgent {
  func saveAvatarData(data: Data) -> Void
  func savePostImageData(data: Data) -> Void
}
