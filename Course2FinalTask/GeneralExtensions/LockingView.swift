import UIKit

final class LockingView {
  static var window: UIWindow? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
  static let activityIndicator = UIActivityIndicatorView(frame: window?.bounds ?? UIScreen.main.bounds)

  static func lock() {
    prepareIndicator()
    DispatchQueue.main.async {
      activityIndicator.startAnimating()
    }
  }

  static func unlock() {
    DispatchQueue.main.async {
      activityIndicator.stopAnimating()
      activityIndicator.removeFromSuperview()
    }
  }

  static private func prepareIndicator() {
    DispatchQueue.main.async {
      activityIndicator.backgroundColor = .white.withAlphaComponent(0.7)
      activityIndicator.color = .darkGray
      activityIndicator.style = .large
      window?.addSubview(activityIndicator)
    }
  }
}
