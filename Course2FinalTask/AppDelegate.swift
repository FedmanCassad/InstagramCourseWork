import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
    initiateWindow()
    return true
  }

  private func initiateWindow() {
    let loginViewController = LoginViewController() { [weak self] in
      let tabBarController = InstaTabBarController()
      self?.window?.rootViewController = tabBarController
      UIView.transition(with: window,
                       duration: 0.3,
                       options: .transitionFlipFromLeft,
                       animations: nil,
                       completion: nil)
    }
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = loginViewController
    window?.makeKeyAndVisible()
  }
}
