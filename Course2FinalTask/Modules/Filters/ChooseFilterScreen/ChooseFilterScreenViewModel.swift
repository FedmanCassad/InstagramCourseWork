import UIKit

protocol IChooseFilterScreenViewModel {

  /// Картинка с которой работаем, для удобства завернута в Dynamic. Контроллер отображает её в большой UIImageView.
  var mainImage: Dynamic<UIImage> { get set }

  /// Замыкание куда уходит отфильтрованная картинка для отображения в контроллер на большой UIImageView.
  var applyFilteredImage: ((UIImage) -> Void)? { get set }

  /// Ключи фильтрации.
  var filterKeys: [String] { get }

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get set }
}

final class ChooseFilterScreenViewModel: NSObject, IChooseFilterScreenViewModel {

  var applyFilteredImage: ((UIImage) -> Void)?
  var mainImage: Dynamic<UIImage>
  var error: Dynamic<ErrorHandlingDomain?>

  let effectsKeys: [String] = [
    FilterKeys.CISepiaTone,
    FilterKeys.CIColorInvert,
    FilterKeys.CIGaussianBlur,
    FilterKeys.CIVignette,
    FilterKeys.CIPixellate,
    FilterKeys.CITwirlDistortion
  ]

  var filterKeys: [String] = []
  let processingQueue = OperationQueue()
  init(image: UIImage) {
    self.mainImage = Dynamic(image)
    error = Dynamic(nil)
  }
  
}

extension ChooseFilterScreenViewModel: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    effectsKeys.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let viewModel = FilterThumbnailCellViewModel(
      filterKey: effectsKeys[indexPath.item],
      queue: processingQueue,
      image: mainImage.value)
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: FiltersThumbnailCell.identifier,
      for: indexPath
    ) as? FiltersThumbnailCell else {
      return UICollectionViewCell()
    }
    cell.configure(viewModel: viewModel, delegate: self)
    return cell
  }
}

extension ChooseFilterScreenViewModel: FiltersThumbnailCellDelegate {
  func passError(error: ErrorHandlingDomain) {
    self.error.value = error
  }

  func filterChosen(image: UIImage) {
    applyFilteredImage?(image)
  }
}
