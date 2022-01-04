import UIKit

protocol IAddImageScreenViewModel: AnyObject {

  /// Массив картинок которые ищутся в бандле. (Лежат в директории New).
  var library: [UIImage] { get set }

  /// Ошибка, обернута в Dynamic для удобства, в случае присвоения любой ошибки переменной value - вызывается замыкание
  /// listener - в нашем случае демонстрируется alertController с данным из ошибки.
  var error: Dynamic<ErrorHandlingDomain?> { get }

  /// Обработчик нажатия на картинку для связи с контроллером. В замыкание передается объект UIImage для инициализации
  /// контроллера выбора фильтров и его демонстрации.
  var imageHasBeenSelected: ((UIImage) -> Void)? { get set }
}

final class AddImageScreenViewModel: NSObject, IAddImageScreenViewModel {
  var imageHasBeenSelected: ((UIImage) -> Void)?
private let processingQueue = OperationQueue()

  lazy var library: [UIImage] = {
    var images: [UIImage] = []
    guard let filesCount = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil)?.count else {
      return [UIImage]()
    }
    for i in 1...filesCount {
      guard let path = Bundle.main.path(forResource: "new\(i)", ofType: "jpg"),
            let image = UIImage(contentsOfFile: path) else { return [UIImage]() }
      images.append(image)
    }
    return images
  }()

  var error: Dynamic<ErrorHandlingDomain?> = Dynamic(nil)
}

extension AddImageScreenViewModel: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    library.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseImageCell.identifier,
                                                        for: indexPath) as? ChooseImageCell else {
      return UICollectionViewCell()
    }
    cell.configureForPhotosLibrary(library[indexPath.item], delegate: self)
    return cell
  }
}

extension AddImageScreenViewModel: ChooseImageCellDelegate {
  func imageSelected(image: UIImage) {
    imageHasBeenSelected?(image)
  }
}
