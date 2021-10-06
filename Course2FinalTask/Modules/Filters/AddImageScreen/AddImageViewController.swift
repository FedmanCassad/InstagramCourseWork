import UIKit

final class AddImageViewController: UIViewController {

  var viewModel: IAddImageScreenViewModel

  lazy var imagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    imagesCollectionView.backgroundColor = .white
    imagesCollectionView.dataSource = viewModel as? AddImageScreenViewModel
    imagesCollectionView.delegate = self
    imagesCollectionView.isScrollEnabled = true
    imagesCollectionView.toAutoLayout()
    imagesCollectionView.register(ChooseImageCell.self, forCellWithReuseIdentifier: ChooseImageCell.identifier)
    return imagesCollectionView
  }()

  init(viewModel: IAddImageScreenViewModel = AddImageScreenViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    view.addSubview(imagesCollectionView)
    setupBindings()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .light
    view.backgroundColor = .white
  }
  override func viewDidLayoutSubviews() {
    activateConstraints()
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate([
      imagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      imagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      imagesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  private func setupBindings() {
    viewModel.imageHasBeenSelected = {[weak self] image in
      let chooseFilterVC = ChooseFilterViewController(ChooseFilterScreenViewModel(image: image))
      self?.navigationController?.pushViewController(chooseFilterVC, animated: true)
    }

    viewModel.error.bind {[weak self] error in
      self?.alert(error: error ?? ErrorHandlingDomain.unknownError)
    }
  }
}

extension AddImageViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sideLength = view.frame.width / 3
    return CGSize(width: sideLength, height: sideLength)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    0
  }
}
