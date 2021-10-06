import UIKit

protocol ISharePostScreenViewModel: AnyObject {
  var error: Dynamic<ErrorHandlingDomain?> { get }
  var description: String { get set }
  var imageToShare: UIImage { get }
  var sharingSuccessful: (() -> Void)? { get set }
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
