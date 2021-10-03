import UIKit


protocol UsersListCellDelegate {
  func profileCellTapped(by user: User) -> Void
}

final class UsersListViewController: UIViewController {

  //MARK: - Props
  let viewModel: IUsersListViewModel
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .singleLine
    tableView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    tableView.rowHeight = 45
    tableView.toAutoLayout()
    tableView.register(UsersListCell.self, forCellReuseIdentifier: UsersListCell.identifier)
    return tableView
  }()

  //MARK: - Init here
  init(with viewModel: IUsersListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    view.backgroundColor = .white
  }

  override func viewDidLayoutSubviews() {
    activateConstraints()
  }

  //MARK: - Activating autolayout constraints
  private func activateConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

//MARK: - UITableView delegate methods
extension UsersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let profileViewModelToShow = viewModel.getProfileViewModel(forUserAt: indexPath)
    let profileVC = ProfileViewController(with: profileViewModelToShow)
    navigationController?.pushViewController(profileVC, animated: false)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    45
  }
}

extension UsersListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = viewModel.getCellViewModel(atIndexPath: indexPath)
    viewModel.delegate = self
    guard let cell =  tableView.dequeueReusableCell(withIdentifier: UsersListCell.identifier,
                                                    for: indexPath) as? UsersListCell else {
      return UITableViewCell()
    }
    cell.configure(with: viewModel)
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRows
  }
}

//MARK: - Forwarding user from cell by delegate pattern
extension UsersListViewController: UsersListCellDelegate {
  func profileCellTapped(by user: User) {
    let profileVC = ProfileViewController(with: ProfileViewModel(user: user))
    navigationController?.pushViewController(profileVC, animated: true)
  }
}

