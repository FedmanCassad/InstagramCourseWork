//
//  FeedViewModelTests.swift
//  InstagramFeedTests
//
//  Created by Vladimir Banushkin on 07.10.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//
@testable import InstagramFeed
import XCTest

class FeedViewModelTests: XCTestCase {

  var mockModel: IFeedViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    mockModel = FeedViewModel()
   preparationToGetWorkingToken()
  }

  override func tearDownWithError() throws {
    mockModel = nil
    try super.tearDownWithError()
  }

  // Use only after
  func testRequestFeedPostsPostsShouldHaveMoreThenZeroPostsStored () {
    let expectation = expectation(description: "feedRequest")
    mockModel.requestFeedPosts { result in
      switch result {
      case .failure(let error):
        self.mockModel.error.value = error
        expectation.fulfill()
      case .success(let feed):
        self.mockModel.posts = feed
        expectation.fulfill()
      }
    }
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertGreaterThan(mockModel.posts.count, 0)
  }

  private func preparationToGetWorkingToken() {
    let expectation = expectation(description: "awaitingToken")
    DataProviderFacade
      .shared
      .loginToServer(
        signInModel: SignInModel(login: "user", password: "qwerty")
      ) { result in
        switch result {
        case .failure(let error):
          self.mockModel.error.value = error
          expectation.fulfill()
          return
        case .success(let token):
          KeychainService.saveToken(token: token.token)
          expectation.fulfill()
        }
      }
    waitForExpectations(timeout: 3, handler: nil)
  }
}
