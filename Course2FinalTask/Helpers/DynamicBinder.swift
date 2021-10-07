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
