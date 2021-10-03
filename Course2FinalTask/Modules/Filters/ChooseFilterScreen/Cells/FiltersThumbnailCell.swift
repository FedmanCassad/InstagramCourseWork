import UIKit

protocol FiltersThumbnailCellDelegate {
  func filterChosen(image: UIImage) -> Void
}
final class FiltersThumbnailCell: UICollectionViewCell {

  static let identifier = String(describing: self)
  var delegate: FiltersThumbnailCellDelegate?

  private lazy var thumbnailImage: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    imageView.toAutoLayout()
    imageView.addGestureRecognizer(selectFilterGestureRecognizer)
    return imageView
  }()

  private lazy var filterLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.numberOfLines = 1
    label.textAlignment = .center
    label.toAutoLayout()
    return label
  }()

  private lazy var selectFilterGestureRecognizer: UITapGestureRecognizer = {
    let gr = UITapGestureRecognizer(target: self, action: #selector(applyFilter))
    return gr
  }()

  var viewModel: IFilterThumbnailCellViewModel?

  //Initialization
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(thumbnailImage)
    contentView.addSubview(filterLabel)
    activateConstraints()
  }


  private func activateConstraints() {
    NSLayoutConstraint.activate([
      thumbnailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      thumbnailImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor),
      thumbnailImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      filterLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor),
      filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      filterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  func configure(viewModel: IFilterThumbnailCellViewModel, delegate: FiltersThumbnailCellDelegate) {
    self.delegate = delegate
    self.viewModel = viewModel
    filterLabel.text = viewModel.filterKey
    thumbnailImage.lockTheView()
    setupBindings()
  }

  private func setupBindings() {
    viewModel?.image.bind {[unowned self] image in
      guard let image = image else { return }
      DispatchQueue.main.async {
      thumbnailImage.unlockTheView()
      thumbnailImage.image = image
      }
    }
  }

  @objc func applyFilter() {
    guard let viewModel = viewModel,
          let image = viewModel.image.value else {
      return
    }
    delegate?.filterChosen(image: image)
  }
}
