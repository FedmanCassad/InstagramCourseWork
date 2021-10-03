import UIKit

class ActivityIndicator: UIView {
  lazy var activityIndicator: UIActivityIndicatorView = {
    var activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.toAutoLayout()
    return activityIndicator
  }()

  override init(frame: CGRect ) {
    super.init(frame: frame)
    backgroundColor = .gray.withAlphaComponent(0.7)
    addSubview(activityIndicator)
    activateConstraints()
  }
  private func activateConstraints() {
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
