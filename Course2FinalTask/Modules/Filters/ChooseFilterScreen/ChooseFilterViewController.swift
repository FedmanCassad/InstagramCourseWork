import UIKit

class ChooseFilterViewController: UIViewController {
  var viewModel: IChooseFilterScreenViewModel

  lazy var mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.toAutoLayout()
    return imageView
  }()

  lazy var filterThumbnails: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return collectionView
    }
    collectionView.register(FiltersThumbnailCell.self, forCellWithReuseIdentifier: FiltersThumbnailCell.identifier)
    flowLayout.scrollDirection = .horizontal
    collectionView.isScrollEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.dataSource = viewModel as? ChooseFilterScreenViewModel
    collectionView.delegate = self
    collectionView.toAutoLayout()
    return collectionView
  }()

  init(_ viewModel: IChooseFilterScreenViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    view.addSubview(mainImageView)
    view.addSubview(filterThumbnails)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Next",
      style: .plain,
      target: self,
      action: #selector(goToSharePostVC)
    )
    setupBindings()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    mainImageView.image = viewModel.mainImage.value
    view.backgroundColor = .white
  }

  override func viewDidLayoutSubviews() {
    activateConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupBindings() {
    viewModel.mainImage.bind {[unowned self] image in
      mainImageView.image = image
    }

    viewModel.applyFilteredImage = {[weak self] image in
      self?.mainImageView.image = image
    }

    viewModel.error.bind {[unowned self] error in
      guard let error = error else { return }
      alert(error: error)
    }
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate([
      mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
      filterThumbnails.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
      filterThumbnails.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      filterThumbnails.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      filterThumbnails.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  @objc func goToSharePostVC() {
    guard let image = mainImageView.image else { return }
    let targetVC = SharePostViewController(SharePostScreenViewModel(with: image))
    navigationController?.pushViewController(targetVC, animated: true)
  }
}

extension ChooseFilterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let height = view.safeAreaLayoutGuide.layoutFrame.height - mainImageView.frame.height
    let width = view.frame.width / 3
    return CGSize(width: width, height: height)
  }
}
