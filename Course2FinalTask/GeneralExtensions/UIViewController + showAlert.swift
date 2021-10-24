import UIKit

// MARK: - Error displaying
extension UIViewController {
  func alert(error: ErrorHandlingDomain, handler: ((UIAlertAction) -> Void )? = nil) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(
				title: error.localizedDescription.0,
				message: error.localizedDescription.1,
				preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
