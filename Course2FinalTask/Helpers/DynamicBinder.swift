import Foundation

// TODO: Лучше написать документацию о том, что это за класс, для чего служит и когда применяется. Его открытые свойства и методы тоже стоит описать.
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
