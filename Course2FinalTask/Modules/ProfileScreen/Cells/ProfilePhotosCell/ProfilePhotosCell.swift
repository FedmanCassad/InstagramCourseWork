import UIKit

final class ProfilePhotosCell: UICollectionViewCell {

	static let identifier = String(describing: self)

	private lazy var image: UIImageView = {

		let imgView = UIImageView()
		imgView.toAutoLayout()
		return imgView
	}()

	func configure(with url: URL) {
    var tempUrl = url
    if NetworkEngine.shared.location == .LANIP {
		tempUrl = URL(string: url.absoluteString.replacingOccurrences(of: "localhost", with: "172.16.9.185"))!
    }
		contentView.clipsToBounds = true
		image.kf.setImage(with: tempUrl)
		contentView.addSubview(image)
		activateConstraints()
	}

	private func activateConstraints() {
		NSLayoutConstraint.activate([
			image.topAnchor.constraint(equalTo: contentView.topAnchor),
			image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

		])
	}

}
