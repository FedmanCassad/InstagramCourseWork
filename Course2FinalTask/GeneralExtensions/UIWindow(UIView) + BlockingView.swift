import UIKit

extension UIView {
  func lockTheView() {
    let lockView = UIActivityIndicatorView(frame: self.bounds)
    lockView.toAutoLayout()
    self.addSubview(lockView)
    NSLayoutConstraint.activate([
      lockView.leadingAnchor.constraint(equalTo: leadingAnchor),
      lockView.topAnchor.constraint(equalTo: topAnchor),
      lockView.trailingAnchor.constraint(equalTo: trailingAnchor),
      lockView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    lockView.startAnimating()
  }

  func unlockTheView() {
    subviews.forEach {subview in
      if subview is UIActivityIndicatorView {
        DispatchQueue.main.async {
          subview.removeFromSuperview()
        }
      }
    }
  }
}
