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
    let loginViewController = LoginViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = loginViewController
    window?.makeKeyAndVisible()
  }
}
