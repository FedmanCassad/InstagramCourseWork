import UIKit

protocol ChooseImageCellDelegate {
  func imageSelected(image: UIImage)
}

final class ChooseImageCell: UICollectionViewCell {

  private lazy var galleryImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.toAutoLayout()
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(imageTapRecognizer)
    return imageView
  }()

  private lazy var imageTapRecognizer: UITapGestureRecognizer = {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToFiltersSelection))
    return tapRecognizer
  }()

  var delegate: ChooseImageCellDelegate?
  static let identifier = String(describing: self)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(galleryImageView)
    activateConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureForPhotosLibrary(_ image: UIImage, delegate: ChooseImageCellDelegate) {
    self.delegate = delegate
    galleryImageView.image = image
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate([
      galleryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      galleryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      galleryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      galleryImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  @objc func goToFiltersSelection() {
    guard let image = galleryImageView.image else {
      return
    }
    delegate?.imageSelected(image: image)
  }
}
