import Foundation

class Dynamic<T> {
    /// Dynamic class is kind of wrapper class to make viewModel-model bindings easier by reducing
    /// count of closure declarations in viewModel. The value encapsulated in Dynamic<T> class becomes something like 'observable',
    /// we bind some code to execute in case of changing encapsulated value.
    // RESOLVED: - Позанимался немного английским.
    typealias Listener = (T) -> Void

    /// - listener: the closure which is going to be executed in case of receiving value.
    var listener: Listener?

    /// - value: observable value
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
