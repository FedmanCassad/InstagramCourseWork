import UIKit

final class UsersListCell: UITableViewCell {

  // MARK: - Props
  static let identifier = String(describing: self)
  var viewModel: IUsersListCellViewModel?
  let leadingMargin: CGFloat = 15

  var singleTapRecognizer: UITapGestureRecognizer {
    let tchRecg = UITapGestureRecognizer(target: self, action: #selector(selectProfile))
    tchRecg.numberOfTapsRequired = 1
    tchRecg.numberOfTouchesRequired = 1
    return tchRecg
  }

  private lazy var avatarImage: UIImageView = {
    let img = UIImageView()
    img.clipsToBounds = true
    img.contentMode = .scaleAspectFit
    img.isUserInteractionEnabled = true
    img.toAutoLayout()
    img.addGestureRecognizer(singleTapRecognizer)
    return img
  }()

  private lazy var userName: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    lbl.toAutoLayout()
    lbl.addGestureRecognizer(singleTapRecognizer)
    lbl.isUserInteractionEnabled = true
    return lbl
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(avatarImage)
    contentView.addSubview(userName)
    activateConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with viewModel: IUsersListCellViewModel) {
    self.viewModel = viewModel
    setupBindings()
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate([
      avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingMargin),
      avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor),
      avatarImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      userName.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
      userName.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor)
    ])
  }

  private func setupBindings() {
    viewModel?.user.bindAndPerform {[unowned self] tempUser in
      let user = tempUser
      if NetworkEngine.shared.location == .LANIP {
        user.avatar = URL(
          string: user.avatar.absoluteString.replacingOccurrences(
            of: "http://localhost:8080",
            with: NetworkEngine.shared.location.serverURL.absoluteString
          )
        )!
      }
      DispatchQueue.main.async {[user] in
        self.avatarImage.kf.setImage(with: user.avatar,
                                     placeholder: R.image.imagePlaceholder(),
                                     options: [.transition(.fade(0.3))])
        self.userName.text = user.fullName
      }
    }
  }

  @objc func selectProfile() {
    viewModel?.userCellSelected()
  }

}
