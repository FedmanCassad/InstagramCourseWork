import UIKit

class SharePostViewController: UIViewController {

  lazy var postImage: UIImageView = {
    let imageView = UIImageView()
    imageView.toAutoLayout()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Add description"
    label.textColor = .black
    label.toAutoLayout()
    return label
  }()

  lazy var descriptionTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
    textField.toAutoLayout()
    return textField
  }()

  lazy var descriptionTextFieldHeightConstraint = descriptionTextField.heightAnchor.constraint(equalToConstant: 35)

  let viewModel: ISharePostScreenViewModel

  init(_ viewModel: ISharePostScreenViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    postImage.image = viewModel.imageToShare

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(sharePost))
    view.backgroundColor = .white
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .light
    view.backgroundColor = .white
    [postImage, descriptionLabel, descriptionTextField].forEach {
      view.addSubview($0)
    }
    setupBindings()
  }

  override func viewDidLayoutSubviews() {
    activateConstraints()
  }

  private func setupBindings() {
    viewModel.sharingSuccessful = {[weak self] in
      guard let self = self,
            let tabBar = self.tabBarController as? InstaTabBarController else {
        return

      }
      tabBar.feedVC.setNeedsRequestPosts = true
      tabBar.feedVC.scrollToLastPost()
      DispatchQueue.main.async {
        tabBar.selectedIndex = 0
        tabBar.newPostNavigationController.popToRootViewController(animated: false)
        tabBar.feedNavigationController.popToRootViewController(animated: false)
      }
    }

    viewModel.error.bind {[unowned self] error in
      guard let error = error else { return }
      alert(error: error)
    }
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate(
      [
        postImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        postImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        postImage.widthAnchor.constraint(equalToConstant: 100),
        postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor),
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        descriptionLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 32),
        descriptionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        descriptionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8)
      ]
    )
  }

  @objc func sharePost() {
    viewModel.shareButtonTapped()
  }

  @objc func textChanged(sender: UITextField) {
    viewModel.description = sender.text ?? ""
  }
}
