import UIKit

final class InstaTabBarController: UITabBarController {

	enum Titles {
    static let feed = R.string.localizable.feedControllerTitle()
    static let addPost = R.string.localizable.newPostControllerTitle()
    static let profile = R.string.localizable.profileControllerTitle()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setTabs()
    overrideUserInterfaceStyle = .light
	}

  lazy var feedVC = FeedViewController(viewModel: FeedViewModel())
  lazy var feedNavigationController = UINavigationController(rootViewController: feedVC)
  lazy var addImageScreenVC = AddImageViewController()
  lazy var newPostNavigationController = UINavigationController(rootViewController: addImageScreenVC)
  lazy var profileVC = ProfileViewController(with: ProfileViewModel())
  lazy var profileNavigationController = UINavigationController(rootViewController: profileVC)

	private func setTabs() {
		feedVC.title = Titles.feed
    feedNavigationController.overrideUserInterfaceStyle = .light
		feedNavigationController.tabBarItem.image = R.image.feed()

    addImageScreenVC.title = Titles.addPost
    addImageScreenVC.overrideUserInterfaceStyle = .light
		newPostNavigationController.tabBarItem.image = R.image.plus()

		profileVC.title = Titles.profile
    profileNavigationController.overrideUserInterfaceStyle = .light
		profileNavigationController.tabBarItem.image = R.image.profile()

		self.viewControllers = [feedNavigationController, newPostNavigationController, profileNavigationController]
	}
}
