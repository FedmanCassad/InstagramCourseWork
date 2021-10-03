import UIKit

extension UIWindow {

  func lockTheWindow() {
    DispatchQueue.main.async {[weak self] in
      guard let self = self else { return }
      let lockView = ActivityIndicator(frame: self.bounds)
      self.addSubview(lockView)
      lockView.activityIndicator.startAnimating()
    }
  }

  func unlockTheWindow() {
    DispatchQueue.main.async {[weak self] in
      self?.subviews.forEach {subview in
        if subview is ActivityIndicator {
          DispatchQueue.main.async {[weak subview] in
            subview?.removeFromSuperview()
          }
        }
      }
    }
  }
}

extension UIView {

  func lockTheView() {
    let lockView = ActivityIndicator(frame: self.bounds)
    lockView.toAutoLayout()
    self.addSubview(lockView)
    NSLayoutConstraint.activate([
      lockView.leadingAnchor.constraint(equalTo: leadingAnchor),
      lockView.topAnchor.constraint(equalTo: topAnchor),
      lockView.trailingAnchor.constraint(equalTo: trailingAnchor),
      lockView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    lockView.activityIndicator.startAnimating()
  }

  func unlockTheView() {
    subviews.forEach {subview in
      if subview is ActivityIndicator {
        DispatchQueue.main.async {
          subview.removeFromSuperview()
        }
      }
    }
  }
}
