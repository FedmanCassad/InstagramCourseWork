import UIKit

protocol ISharePostScreenViewModel: AnyObject {

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get }

  /// Описание новой публикации
  var description: String { get set }

  /// Объект UIImage для публикации.
  var imageToShare: UIImage { get }

  /// Замыкание вызываемое после удачной публикации.
  var sharingSuccessful: (() -> Void)? { get set }

  /// Публикация происходит здесь.
  func shareButtonTapped ()
}

final class SharePostScreenViewModel: ISharePostScreenViewModel {
  let provider: IDataProviderFacade = DataProviderFacade.shared
  var sharingSuccessful: (() -> Void)?
  var error: Dynamic<ErrorHandlingDomain?>
  let imageToShare: UIImage
  var description: String = ""

  init(with image: UIImage) {
    self.imageToShare = image
    error = Dynamic(nil)
  }

  func shareButtonTapped() {
    provider.uploadPost(image: imageToShare.pngData(), description: description) {[unowned self] result in
      switch result {
      case .success:
        sharingSuccessful?()
      case let .failure(error):
        self.error.value = error
      }
    }
  }
}
