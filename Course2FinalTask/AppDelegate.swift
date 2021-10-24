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
    let loginViewController = LoginViewController() {
      let tabBarController = InstaTabBarController()
      // TODO: Довольно жесткое переключение. Лучше было бы пушить в нав контроллер или анимированно дисмисить окно логин вью контроллера, предварительно установленное модально (без анимации) поверх ленты, чтобы красиво открывалась лента.
      UIApplication.shared.windows.first?.rootViewController = tabBarController
    }
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = loginViewController
    window?.makeKeyAndVisible()
  }
}
