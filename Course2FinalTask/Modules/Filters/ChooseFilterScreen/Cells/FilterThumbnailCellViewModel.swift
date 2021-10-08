import UIKit

protocol IFilterThumbnailCellViewModel {

  /// Картинка для отображения в ячейки. Для удобства завернута в Dynamic.
  var image: Dynamic<UIImage?> { get set }

  /// Ключ фильтрации.
  var filterKey: String { get set }

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае передается модели контроллера для последующего отображения.
  var error: Dynamic<ErrorHandlingDomain?> { get set }
}

final class FilterThumbnailCellViewModel: IFilterThumbnailCellViewModel {
  private let processingImage: UIImage
  let processingQueue: OperationQueue
  var image: Dynamic<UIImage?> = Dynamic(nil)
  var filterKey: String
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
