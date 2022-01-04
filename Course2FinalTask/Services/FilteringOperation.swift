import UIKit

final class FilteringOperation: Operation {
  enum Modifiers {
    static let intensityConst: CGFloat = 0.5
    static let radiusConst: CGFloat = 50
    static let scaleConst: CGFloat = 12.5
    static let centerConst: CIVector = CIVector(x: UIScreen.main.bounds.width / 2,
                                                y: UIScreen.main.bounds.width / 2)
  }

  private var inputImage: UIImage
  private(set) var outputImage: UIImage?
  private var  filterKey: String

  init(image: UIImage, filterKey: String) {
    self.inputImage = image
    self.filterKey = filterKey
  }

  override func main() {
    let context = CIContext()
    guard let preparedImage = CIImage(image: inputImage),
          let filter = CIFilter(name: filterKey) else { return }
    filter.setValue(preparedImage, forKey: kCIInputImageKey)
    setModifiers(for: filter)
    guard let filteredCImage = filter.outputImage,
          let filteredCGImage = context.createCGImage(filteredCImage, from: filteredCImage.extent) else { return }
    outputImage = UIImage(cgImage: filteredCGImage)
  }

  private func setModifiers(for filter: CIFilter) {
    if filter.inputKeys.contains(kCIInputIntensityKey) {
      filter.setValue(Modifiers.intensityConst, forKey: kCIInputIntensityKey)
    }
    if filter.inputKeys.contains(kCIInputRadiusKey) {
      filter.setValue(Modifiers.radiusConst, forKey: kCIInputRadiusKey)
    }
    if filter.inputKeys.contains(kCIInputScaleKey) {
      filter.setValue(Modifiers.scaleConst, forKey: kCIInputScaleKey)
    }
    if filter.inputKeys.contains(kCIInputCenterKey) {
      filter.setValue(Modifiers.centerConst, forKey: kCIInputCenterKey)
    }
  }
}
