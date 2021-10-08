import Kingfisher
import UIKit

final class FeedCell: UITableViewCell {

  public enum LikeColor {
    static let isLiked = UIColor.systemBlue
    static let notLiked = UIColor.systemGray
  }

  static var identifier: String {
    String(describing: Self.self)
  }
  var viewModel: IFeedCellViewModel?

  // MARK: - Top footer (avatar, nickname, created time)
  private lazy var avatarImageView: UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFit
    img.clipsToBounds = true
    img.isUserInteractionEnabled = true
    img.toAutoLayout()
    return img
  }()

  private lazy var userName: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.toAutoLayout()
    label.numberOfLines = 1
    label.isUserInteractionEnabled = true
    return label
  }()

  private lazy var timeStamp: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.toAutoLayout()
    label.numberOfLines = 1
    return label
  }()

  // MARK: - Post picture
  private lazy var postImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.toAutoLayout()
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    imageView.clipsToBounds = true
    return imageView
  }()

  // MARK: - Footer
  private lazy var likesDisplayButton: UIButton = {
    let button = UIButton(type: .system)
    button.toAutoLayout()
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.sizeToFit()
    button.addTarget(self, action: #selector(likesCountTapped), for: .touchUpInside)
    button.isUserInteractionEnabled = true
    return button
  }()

  private lazy var likeButton: UIButton = {
    let button = UIButton(type: .custom)
    let img = R.image.like()
    button.setImage(img, for: .normal)
    button.tintColor = .lightGray
    button.sizeToFit()
    button.toAutoLayout()
    button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var commentLabel: UILabel = {
    let button = UILabel()
    button.numberOfLines = 1
    button.toAutoLayout()
    return button
  }()

  private lazy var bigLike: UIImageView = {
    let img = R.image.bigLike()
    let imgView = UIImageView(image: img)
    imgView.tintColor = .white
    imgView.layer.opacity = 0
    imgView.toAutoLayout()
    return imgView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    [avatarImageView,
     userName,
     postImageView,
     timeStamp,
     likeButton,
     likesDisplayButton,
     bigLike,
     commentLabel
    ]
    .forEach {
      contentView.addSubview($0)
    }
    activateConstraints()
    setupGestureRecognizers()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    setupBindings()
    guard let viewModel = viewModel else { return }
    commentLabel.text = viewModel.postDescription
    userName.text = viewModel.authorUsername
    timeStamp.text = viewModel.createdTime
    likeButton.tintColor = viewModel.currentUserLikesThisPost
      ? LikeColor.isLiked
      : LikeColor.notLiked
    likesDisplayButton.setTitle(viewModel.likedByCount, for: .normal)
    postImageView.kf.setImage(with: viewModel.imageURL,
                              placeholder: R.image.imagePlaceholder(),
                              options: [.transition(.fade(0.2))],
                              completionHandler: {[weak self] result in
                                switch result {
                                case .failure:
                                    guard let data = viewModel.postImageData else { return }
                                    self?.postImageView.image = UIImage(data: data)
                                    self?.layoutIfNeeded()
                                    return
                                case let .success(image):
                                    guard self?.viewModel?.postImageData == nil,
                                          let data = image.image.pngData() else { return }
                                    self?.viewModel?.savePostImageData(data: data)
                                }
                              })
    avatarImageView.kf.setImage(with: viewModel.authorAvatarURL,
                                placeholder: R.image.imagePlaceholder(),
                                options: [.transition(.fade(0.2))],
                                completionHandler: {[weak self] result in
                                  switch result {
                                  case .failure:
                                      guard let data = viewModel.avatarImageData else { return }
                                      self?.avatarImageView.image = UIImage(data: data)
                                      self?.layoutIfNeeded()
                                      return
                                  case let .success(image):
                                      guard self?.viewModel?.avatarImageData == nil,
                                            let data = image.image.pngData() else { return }
                                      self?.viewModel?.saveAvatarData(data: data)
                                  }
                                })
  }

  override func layoutSubviews() {
    avatarImageView.clipsToBounds = true
    avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
  }

  // MARK: - Tap recognizers setup
  private func setupGestureRecognizers() {
    // Recognizer for big like image animating
    let postImageGR = UITapGestureRecognizer(target: self, action: #selector(postImageTapped))
    postImageGR.numberOfTapsRequired = 2
    postImageView.addGestureRecognizer(postImageGR)

    // Recognizer for pushing profile controller after avatar image tapped
    let authorAvatarTappedGR = UITapGestureRecognizer(target: self, action: #selector(authorTapped))
    let authorUsernameTappedGR = UITapGestureRecognizer(target: self, action: #selector(authorTapped))

    avatarImageView.addGestureRecognizer(authorAvatarTappedGR)
    userName.addGestureRecognizer(authorUsernameTappedGR)
  }

  func cancelImagesLoading() {
    avatarImageView.kf.cancelDownloadTask()
    postImageView.kf.cancelDownloadTask()
  }

  // MARK: - Setup bindings

  private func setupBindings() {
    viewModel?.likesDataUpdatedAnimation = {[unowned self]  in
      guard let viewModel = viewModel else { return }
      UIView.animate(withDuration: 0.3) {
        likesDisplayButton.setTitle(viewModel.likedByCount, for: .normal)
        likeButton.tintColor = viewModel.currentUserLikesThisPost ? LikeColor.isLiked : LikeColor.notLiked
      }
    }
  }

  // MARK: - @objc actions for cell
  @objc private func postImageTapped() {
    likeTapped()
  }

  @objc private func authorTapped() {
    viewModel?.authorTapped()
  }

  @objc private func likeTapped() {
    bigLike.appearingAnimated()
    viewModel?.likeTapped()
  }

  @objc private func likesCountTapped() {
    viewModel?.likesCountTapped()
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      avatarImageView.widthAnchor.constraint(equalToConstant: 35),
      avatarImageView.heightAnchor.constraint(equalToConstant: 35),
      userName.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
      userName.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: -5),
      timeStamp.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
      timeStamp.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
      postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
      postImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
      likesDisplayButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
      likesDisplayButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      likesDisplayButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
      likeButton.widthAnchor.constraint(equalToConstant: 44),
      likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
      likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
      likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      commentLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
      commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      bigLike.centerXAnchor.constraint(equalTo: postImageView.centerXAnchor),
      bigLike.centerYAnchor.constraint(equalTo: postImageView.centerYAnchor)
    ])
  }
}
