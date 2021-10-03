import UIKit

protocol IChooseFilterScreenViewModel {
  var mainImage: Dynamic<UIImage> { get set }
  var applyFilteredImage: ((UIImage) -> Void)? { get set }
  var filterKeys: [String] { get }
}

final class ChooseFilterScreenViewModel: NSObject, IChooseFilterScreenViewModel {
  var applyFilteredImage: ((UIImage) -> Void)?
  var mainImage: Dynamic<UIImage>
  
  let effectsKeys: [String] = [
    FilterKeys.CISepiaTone,
    FilterKeys.CIColorInvert,
    FilterKeys.CIGaussianBlur,
    FilterKeys.CIVignette,
    FilterKeys.CIPixellate,
    FilterKeys.CITwirlDistortion
  ]

  var filterKeys: [String] = [String]()
  let processingQueue = OperationQueue()
  init(image: UIImage) {
    self.mainImage = Dynamic(image)
  }
}

extension ChooseFilterScreenViewModel: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    effectsKeys.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let viewModel = FilterThumbnailCellViewModel(filterKey: effectsKeys[indexPath.item],
                                                 queue: processingQueue,
                                                 image: mainImage.value)
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersThumbnailCell.identifier,
                                                        for: indexPath) as? FiltersThumbnailCell else {
      return UICollectionViewCell()
    }
    cell.configure(viewModel: viewModel, delegate: self)
    return cell
  }
}

extension ChooseFilterScreenViewModel: FiltersThumbnailCellDelegate {
  func filterChosen(image: UIImage) {
    applyFilteredImage?(image)
  }
}
