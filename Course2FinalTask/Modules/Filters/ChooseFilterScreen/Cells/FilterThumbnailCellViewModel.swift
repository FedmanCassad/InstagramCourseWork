import UIKit

protocol IFilterThumbnailCellViewModel {
  var image: Dynamic<UIImage?> { get set }
  var filterKey: String { get set }
  var error: Dynamic<ErrorHandlingDomain?> { get }
}

final class FilterThumbnailCellViewModel: IFilterThumbnailCellViewModel {
  var image: Dynamic<UIImage?> = Dynamic(nil)
  private let processingImage: UIImage
  var filterKey: String
  let processingQueue: OperationQueue
  var error: Dynamic<ErrorHandlingDomain?> = Dynamic(nil)
  
  init(filterKey: String, queue: OperationQueue, image: UIImage) {
    self.filterKey = filterKey
    self.processingQueue = queue
    self.processingImage = image
    processImage()
  }
  
  
  private func processImage() {
    let operation = FilteringOperation(image: processingImage, filterKey: filterKey)
    operation.completionBlock = {[weak self] in
      guard let image = operation.outputImage else { return }
      self?.image.value = image
    }
    processingQueue.addOperation(operation)
  }
}
