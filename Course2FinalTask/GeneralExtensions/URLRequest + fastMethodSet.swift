//
//  URLRequest + fastMethodSet.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 02.06.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

extension URLRequest {
  mutating func setToPostMethod() {
    self.httpMethod = HTTPMethod.POST.rawValue
  }

  mutating func setToGetMethod() {
    self.httpMethod = HTTPMethod.GET.rawValue
  }
}

extension URLRequest {
  mutating func injectBodyPayload<T: Encodable>(payload: T) {
    self.httpBody = try? JSONEncoder().encode(payload)
  }
}
