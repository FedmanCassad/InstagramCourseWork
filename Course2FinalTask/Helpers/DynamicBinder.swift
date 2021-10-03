//
//  DynamicBinder.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 23.05.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

class Dynamic<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ val: T) {
    value = val
  }

  func bind(listener: Listener?) {
    self.listener = listener
  }

  func bindAndPerform(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
