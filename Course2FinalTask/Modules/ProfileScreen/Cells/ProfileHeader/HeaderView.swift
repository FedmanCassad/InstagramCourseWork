import UIKit

class HeaderView: UICollectionReusableView {

	static let identifier = String(describing: self)
	var viewModel: IProfileHeaderViewModel?
  var imageCaching: ImageCachingClosure!
	lazy var avatar: UIImageView = {
		let imgView = UIImageView()
		imgView.clipsToBounds = true
		imgView.toAutoLayout()
		return imgView
	}()

	lazy var fullNameLabel: UILabel = {
		let label = UILabel()
		label.toAutoLayout()
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .black
		label.numberOfLines = 1
		return label
	}()

	lazy var followersInfoButton: UIButton = {
    let button = UIButton(type: .system)
		button.toAutoLayout()
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(followersListRequested(sender:)), for: .touchUpInside)
		button.isUserInteractionEnabled = true
		return button
	}()

	lazy var followingsInfoButton: UIButton = {
    let button = UIButton(type: .system)
		button.toAutoLayout()
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    button.addTarget(self, action: #selector(followersListRequested(sender:)), for: .touchUpInside)
    button.setTitleColor(.black, for: .normal)
		button.isUserInteractionEnabled = true
		return button
	}()

	lazy var followOrUnfollowButton: UIButton = {
    let button = UIButton(type: .system)
		button.toAutoLayout()
		button.layer.cornerRadius = 5
		button.backgroundColor = .systemBlue
		button.tintColor = .white
		button.isUserInteractionEnabled = true
    button.addTarget(self, action: #selector(followersOrFollowButtonTapped), for: .touchUpInside)
		return button
	}()

	lazy var logOutButton: UIButton = {
		let button = UIButton()
		button.toAutoLayout()
		button.setTitle("Log out", for: .normal)
		button.backgroundColor = UIColor.hexStringToUIColor(hex: "#007AFF")
		button.layer.cornerRadius = 5
		button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
		return button
	}()

	lazy var logoutButtonConstraints = [
		logOutButton.centerYAnchor.constraint(equalTo: fullNameLabel.centerYAnchor),
		logOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
		logOutButton.heightAnchor.constraint(equalToConstant: 25),
	]

	lazy var followOrUnfollowButtonConstraints = [
		followOrUnfollowButton.centerYAnchor.constraint(equalTo: fullNameLabel.centerYAnchor),
		followOrUnfollowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
		followOrUnfollowButton.heightAnchor.constraint(equalToConstant: 25),
    followOrUnfollowButton.widthAnchor.constraint(equalToConstant: 75)
	]

  var delegate: HeaderViewDelegate?

	func configure(with viewModel: IProfileHeaderViewModel) {
		addUIElements()
		self.viewModel = viewModel
		setupBindings()
		activateCommonConstraints()
    imageCaching = {[weak self] result in
      switch result {
        case .failure(_):
          guard let data = viewModel.avatarImageData else { return }
          self?.avatar.image = UIImage(data: data)
        case let .success(imageResult):
          guard viewModel.avatarImageData == nil else { return }
          guard let data = imageResult.image.pngData() else { return }
          viewModel.saveAvatarData(data: data)
      }
    }
	}

	private func addUIElements() {
		addSubview(avatar)
		addSubview(fullNameLabel)
		addSubview(followersInfoButton)
		addSubview(followingsInfoButton)
	}

	private func activateCommonConstraints() {
		NSLayoutConstraint.activate([
			avatar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			avatar.widthAnchor.constraint(equalToConstant: 70),
			avatar.heightAnchor.constraint(equalToConstant: 70),
			fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			fullNameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
      fullNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
			followersInfoButton.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
			followersInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      followersInfoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
			followingsInfoButton.centerYAnchor.constraint(equalTo: followersInfoButton.centerYAnchor),
      followingsInfoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
			followingsInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
		])
	}

	private func activateLogoutButtonConstraints() {
		NSLayoutConstraint.activate(logoutButtonConstraints)
	}

	private func activateFollowOrUnfollowButtonConstraints() {
		NSLayoutConstraint.activate(followOrUnfollowButtonConstraints)
	}

	private func addButtons(isCurrentUser: Bool) {
    addSubview(isCurrentUser ? logOutButton : followOrUnfollowButton)
    _ = isCurrentUser ? activateLogoutButtonConstraints() : activateFollowOrUnfollowButtonConstraints()
  }

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		avatar.layer.cornerRadius = avatar.frame.height/2
	}

	private func setupBindings() {
		viewModel?.user.bindAndPerform {[unowned self] user in

      if NetworkEngine.shared.location == .LANIP {
        user.avatar = URL(string: user.avatar.absoluteString.replacingOccurrences(of: "http://localhost:8080", with: NetworkEngine.shared.location.serverURL.absoluteString))!
      }
      DispatchQueue.main.async {

			self.fullNameLabel.text = user.fullName
        self.followersInfoButton.setTitle(viewModel?.followersText, for: .normal)
        self.followingsInfoButton.setTitle(viewModel?.followingsText, for: .normal)
        self.avatar.kf.setImage(with: user.avatar,
                                placeholder: R.image.imagePlaceholder(),
                                completionHandler: imageCaching)
        self.followOrUnfollowButton.setTitle(viewModel?.followOrUnfollowButtonTitle, for: .normal)
      }
		}

		viewModel?.isCurrentUser.bindAndPerform {[unowned self] isCurrentUser in
			addButtons(isCurrentUser: isCurrentUser)
		}

    viewModel?.logoutSuccess?.bind {[unowned self] isLoginSuccess in
      self.delegate?.signOutButtonTapped(logoutSuccess: isLoginSuccess)
    }

    viewModel?.error.bind {[unowned self] error in
      guard let error = error else { return }
      delegate?.showError(error: error)
    }
    viewModel?.followersOfFollowsListUsers = {[unowned self] users in
      delegate?.proceedToUsersList(with: users)
    }
	}

  @objc func logoutButtonTapped() {
    viewModel?.logOut()
  }

  @objc func followersOrFollowButtonTapped() {
    viewModel?.followOrUnfollowButtonTapped()
  }

  @objc func followersListRequested(sender: UIButton) {
    switch sender {
      case followersInfoButton:
        viewModel?.usersListRequested(by: .followers)
      case followingsInfoButton:
        viewModel?.usersListRequested(by: .followings)
      default:
        return
    }
  }
}






