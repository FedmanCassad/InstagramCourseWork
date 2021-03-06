import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties
    // RESOLVED: - В данном случае не нужно, избыточно.
    let viewModel: ILoginViewModel
    private var completion: (() -> Void)?

    // RESOLVED
    private lazy var loginNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.returnKeyType = .next
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.placeholder = R.string.localizable.loginPlaceholder()
        textField.keyboardType = .emailAddress
        textField.toAutoLayout()
        textField.addCornerEffects()
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.returnKeyType = .send
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.placeholder = R.string.localizable.passwordPlaceholder()
        textField.addCornerEffects()
        textField.toAutoLayout()
        return textField
    }()

    private lazy var signInButton: UIButton = {
// RESOLVED
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor("#007AFF")
        button.tintColor = .white
        button.setTitle(R.string.localizable.signInButtonTitle(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.layer.opacity = 0.3
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()

    // MARK: - Initializers

    init(viewModel: ILoginViewModel = LoginViewModel(), completion: (() -> Void)? = nil) {
        self.completion = completion
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        overrideUserInterfaceStyle = .light
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.addSubview(loginNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        setBindings()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkSavedCredentials()
    }

    override func viewDidLayoutSubviews() {
        activateConstraints()
    }

    // MARK: - Activating autolayout constraints
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            loginNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            loginNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameTextField.trailingAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                ),
            loginNameTextField.heightAnchor.constraint(equalToConstant: 45),

            passwordTextField.leadingAnchor.constraint(equalTo: loginNameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginNameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginNameTextField.heightAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginNameTextField.bottomAnchor, constant: 8),

            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signInButton.topAnchor.constraint(greaterThanOrEqualTo: passwordTextField.bottomAnchor, constant: 55),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Configuring bindings
    private func setBindings() {
        viewModel.error.bind { [weak self] error in
            // RESOLVED
            // В error биндится замыкание - когда в модели прилетает из какого-либо сервиса ошибка - она немедленно отображается в alertController'е, но есть нюанс. См ниже.
            guard let error = error else { return }
                DispatchQueue.main.async {
                    // RESOLVED
                    self?.alert(error: error) { _ in
                            // В случае если, нам после отображения ошибки
                        switch error {
                        case .serverUnreachable:
                            self?.viewModel.alertOKButtonTapped()
                            return

                        default:
                            return
                        }
                    }
                }

        }

        viewModel.loginSuccessful = { [weak self] in
            DispatchQueue.main.async {
                self?.completion?()
            }
        }

        viewModel.needFillTextFieldsFromSafeStorage = { [unowned self] login, password in
            loginNameTextField.text = login
            passwordTextField.text = password
            viewModel.loginText = login
            viewModel.passwordText = password
            adjustSignInButtonColor()
        }
    }

    private func adjustSignInButtonColor() {
        signInButton.layer.opacity = viewModel.loginButtonOpacityLevel
    }

    // MARK: - Buttons action
    @objc func signInTapped() {
        viewModel.signInButtonTapped()
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginNameTextField {
            passwordTextField.becomeFirstResponder()
            return true
        } else if viewModel.authFieldsNotEmpty {
            view.endEditing(true)
            viewModel.signInButtonTapped()
            return true
        }
        return false
    }

    @objc
    func textChanged(_ sender: UITextField) {
        viewModel.loginText = loginNameTextField.text
        viewModel.passwordText = passwordTextField.text
        signInButton.isEnabled = viewModel.authFieldsNotEmpty
        adjustSignInButtonColor()
    }
}
