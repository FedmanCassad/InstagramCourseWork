//
//  LoginScreenViewModelTests.swift
//  InstagramFeedTests
//
//  Created by Vladimir Banushkin on 07.10.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//
@testable import InstagramFeed
import XCTest

class LoginScreenViewModelTests: XCTestCase {
  var mockModel: ILoginViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockModel = LoginViewModel()
  }
  
  override func tearDownWithError() throws {
    mockModel = nil
    try super.tearDownWithError()
  }
  
  func testIsAuthFieldsAreNotEmptyShouldBeFalseIfLoginArePasswordEmpty () {
    mockModel.loginText = ""
    mockModel.passwordText = ""
    XCTAssertFalse(mockModel.authFieldsNotEmpty)
  }
  
  func testIsAuthFieldsAreNotEmptyShouldBeFalseIfPasswordIsEmpty() {
    mockModel.loginText = "us"
    mockModel.passwordText = ""
    XCTAssertFalse(mockModel.authFieldsNotEmpty)
  }
  
  func testIsAuthFieldsAreNotEmptyShouldBeFalseIfLoginIsEmpty() {
    mockModel.loginText = ""
    mockModel.passwordText = "qw"
    XCTAssertFalse(mockModel.authFieldsNotEmpty)
  }
  
  func testIsAuthFieldsAreNotEmptyShouldBeTrueIfLoginAndPaswordAreFullfilled() {
    mockModel.loginText = "us"
    mockModel.passwordText = "sdf"
    XCTAssertTrue(mockModel.authFieldsNotEmpty)
  }
}
