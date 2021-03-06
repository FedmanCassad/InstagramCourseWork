import UIKit

class HeaderView: UICollectionReusableView {
    
    static let identifier = String(describing: self)
    
    private var viewModel: IProfileHeaderViewModel?
    private var imageCaching: ImageCachingClosure!
    
    private lazy var avatar: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.toAutoLayout()
        return imgView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var followersInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(followersListRequested(sender:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var followingsInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(followersListRequested(sender:)), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var followOrUnfollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(followersOrFollowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.setTitle(R.string.localizable.logOutButtonTitle(), for: .normal)
        button.backgroundColor = UIColor("#007AFF")
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButtonConstraints = [
        logOutButton.centerYAnchor.constraint(equalTo: fullNameLabel.centerYAnchor),
        logOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        logOutButton.heightAnchor.constraint(equalToConstant: 25)
    ]
    
    private lazy var followOrUnfollowButtonConstraints = [
        followOrUnfollowButton.centerYAnchor.constraint(equalTo: fullNameLabel.centerYAnchor),
        followOrUnfollowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        followOrUnfollowButton.heightAnchor.constraint(equalToConstant: 25),
        followOrUnfollowButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 75)
    ]
    
    weak var delegate: HeaderViewDelegate?
    
    func configure(with viewModel: IProfileHeaderViewModel) {
        addUIElements()
        self.viewModel = viewModel
        setupBindings()
        activateCommonConstraints()
        imageCaching = {[weak self] result in
            switch result {
            case .failure:
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
            followersInfoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
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
        avatar.layer.cornerRadius = avatar.frame.height / 2
    }
    
    private func setupBindings() {
        viewModel?.user.bindAndPerform {[unowned self] user in
            
            if NetworkEngine.shared.location == .LANIP {
                user.avatar = URL(
                    string: user.avatar.absoluteString.replacingOccurrences(
                        of: "http://localhost:8080",
                        with: NetworkEngine.shared.location.serverURL.absoluteString
                    )
                )!
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
        
        viewModel?.presentUsersListViewController = { [unowned self] users, updateData in
            delegate?.proceedToUsersList(with: users, updateData: updateData)
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
