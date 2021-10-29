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
      window = UIWindow(frame: UIScreen.main.bounds)
    let loginViewController = LoginViewController() { [weak self] in
        let tabBarController = InstaTabBarController()
      // TODO: Довольно жесткое переключение. Лучше было бы пушить в нав контроллер или анимированно дисмисить окно логин вью контроллера, предварительно установленное модально (без анимации) поверх ленты, чтобы красиво открывалась лента.
        //А можно вот так.
        guard let window = self?.window else { return }
        window.rootViewController = tabBarController
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)

    }

    window?.rootViewController = loginViewController
    window?.makeKeyAndVisible()
  }
}
