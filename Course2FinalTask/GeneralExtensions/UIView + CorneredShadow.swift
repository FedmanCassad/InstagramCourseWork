import UIKit

extension UIView {
  
  // TODO: А есть смысл в методе, который принимает столько значений? Он ничего не облегчает, лучше бы он по умолчанию какие-то параметры инициализировал, чтобы можно было их как-то при желании менять во время инициализации, но чтобы это не было обязательным.
	func addCornerEffects(
		cornerRadius: CGFloat = 0,
		fillColor: UIColor = .white,
		shadowColor: UIColor = .clear,
		shadowOffset: CGSize,
		shadowOpacity: Float,
		shadowRadius: CGFloat,
		borderColor: UIColor,
		borderWidth: CGFloat
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
