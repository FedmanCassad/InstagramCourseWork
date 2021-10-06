import UIKit

final class FeedViewController: UIViewController {

  // MARK: - Props
  private lazy var tableView: UITableView =  {
    let tableView = UITableView()
    tableView.toAutoLayout()
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.estimatedRowHeight = 450
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
    return tableView
  }()

  private var viewModel: IFeedViewModel = FeedViewModel()
  var setNeedsRequestPosts: Bool = false {
    didSet {
      if setNeedsRequestPosts {
        viewModel.requestFeedPosts()
        setNeedsRequestPosts = false
      }
    }
  }

  // MARK: - Init here
  init(viewModel: IFeedViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .light
    tableView.delegate = self
    tableView.dataSource = viewModel.dataSource
    configureDataSource()
    setupBindings()
    view.addSubview(tableView)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.requestFeedPosts()
  }

  override func viewDidLayoutSubviews() {
    setupConstraints()
  }

  // MARK: - Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  // MARK: - Setup bindings with view model here
  private func setupBindings() {
    viewModel.error.bind {[unowned self] error in
      if let error = error {
        DispatchQueue.main.async {
          self.alert(error: error)
        }
      }
    }

    viewModel.updateCellViewModel = {[unowned self] index in
      guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FeedCell else { return }
      cell.viewModel?.post = viewModel.posts[index]
    }

    viewModel.authorTapped = {[weak self] profileViewModel in
      DispatchQueue.main.async {
        let viewController = ProfileViewController(with: profileViewModel)
        self?.navigationController?.pushViewController(viewController, animated: true)
      }
    }

    viewModel.moveToUsersList = {[weak self] users in
      DispatchQueue.main.async {
        let listVC = UsersListViewController(with: UsersListViewModel(with: users))
        self?.navigationController?.pushViewController(listVC, animated: true)
      }
    }
  }

  func scrollToLastPost() {
    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
  }

  // MARK: - Datasource configuration
  private func configureDataSource() {
    viewModel.dataSource = FeedDataSource(tableView: tableView) {tableView, indexPath, _ -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell
      let cellViewModel: IFeedCellViewModel = self.viewModel.constructFeedCellViewModel(at: indexPath)
      cellViewModel.eventHandler = self.viewModel as? FeedViewModel
      cell?.viewModel = cellViewModel
      cell?.configure()
      return cell ?? UITableViewCell()
    }
  }
}

// MARK: - UITableViewDelegate methods here
extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? FeedCell else { return }
    cell.cancelImagesLoading()
  }
}
