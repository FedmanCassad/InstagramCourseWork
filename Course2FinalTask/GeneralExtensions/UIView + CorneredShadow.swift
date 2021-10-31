import UIKit

extension UIView {

    // RESOLVED
    func addCornerEffects(
        cornerRadius: CGFloat = 5,
        fillColor: UIColor = .white,
        shadowColor: UIColor = .black.withAlphaComponent(0.2),
        shadowOffset: CGSize = .zero,
        shadowOpacity: Float = 1.0,
        shadowRadius: CGFloat = 25.0,
        borderColor: UIColor = .clear,
        borderWidth: CGFloat = 0
    ) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.backgroundColor = nil
        self.layer.backgroundColor = fillColor.cgColor
    }
}
