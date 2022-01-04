import UIKit

protocol HeaderViewDelegate: AnyObject {
    func signOutButtonTapped(logoutSuccess: Bool)
    func showError(error: ErrorHandlingDomain)
    func proceedToUsersList(with users: [User], updateData: UpdateFields?)
}

final class ProfileViewController: UIViewController {
    var collectionView: UICollectionView!
    var viewModel: IProfileViewModel

    init (with viewModel: IProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        overrideUserInterfaceStyle = .light
        viewModel.performPostsRequest {
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBindings()
    }

    func configure() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.toAutoLayout()
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.clipsToBounds = true
        collectionView.register(ProfilePhotosCell.self, forCellWithReuseIdentifier: ProfilePhotosCell.identifier)
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.identifier
        )
        activateConstraints()
    }

    private func setupBindings() {
        viewModel.error.bind {[unowned self] error in
            guard let error = error else { return }
            self.alert(error: error)
        }
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource methods
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.identifier,
                for: indexPath
            ) as? HeaderView else { return UICollectionReusableView() }
            let viewModel = ProfileHeaderViewModel(user: viewModel.user)
            header.configure(with: viewModel)
            header.delegate = self
            return header
        default:
            fatalError("Can't cast header")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePhotosCell.identifier,
            for: indexPath
        ) as? ProfilePhotosCell,
              let url = viewModel.receiveURLForSpecificIndexPath(for: indexPath) else {
                  return UICollectionViewCell()
              }
        cell.configure(with: url)
        return cell
    }

}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    var columns: CGFloat { 3 }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 86)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.width / columns
        return CGSize(width: size, height: size)
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

extension ProfileViewController: HeaderViewDelegate {

    func proceedToUsersList(with users: [User], updateData: UpdateFields? = nil) {
        DispatchQueue.main.async {[weak self] in
            let vc = UsersListViewController(with: UsersListViewModel(with: users, updateData: updateData))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func signOutButtonTapped(logoutSuccess: Bool) {
        DispatchQueue.main.async {
            // MARK: - Can do better transition animation here
            if logoutSuccess {
                let vc = LoginViewController(viewModel: LoginViewModel())
                guard let window = UIApplication.shared.windows.first else { return }
                window.rootViewController = vc
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionFlipFromLeft,
                                  animations: nil,
                                  completion: nil)
            } else {
                self.alert(error: .unknownError)
            }
        }
    }

    func showError(error: ErrorHandlingDomain) {
        self.alert(error: error)
    }
}
