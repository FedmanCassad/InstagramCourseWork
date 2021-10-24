import Foundation

protocol ILoginViewModel: AnyObject {
  
  /// Эта Dynamic обертка для ошибки, при установке значения выполняется замыкание переданное через bind
  /// или bindAndPerform.
  var error: Dynamic<ErrorHandlingDomain?> { get }
  
  /// Возвращает false если свойство .text одного из полей пустое, в обратном случае true.
  var authFieldsNotEmpty: Bool { get }
  
  /// Вычисляет уровень прозрачности для кнопки login'а в зависимости от заполненности полей.
  var loginButtonOpacityLevel: Float { get }
  
  /// При любом изменении свойства .text поля для ввода логина, значение поля сохраняется в loginText.
  var loginText: String? { get set }
  
  /// При любом изменении свойства .text поля для ввода пароля, значение поля сохраняется в passwordText.
  var passwordText: String? { get set }
  
  /// Замыкание куда передается логин и пароль сохраненные в KeyChain для заполнения соответствующих полей.
  var needFillTextFieldsFromSafeStorage: ((String, String) -> Void)? { get set }
  
  /// Инициирует действия со стороны viewController (загрузка основных контроллеров и последующее их отображение).
  var loginSuccessful: (() -> Void)? { get set }

  /// Запускает процесс логина.
  func signInButtonTapped()

  /// При наличии в Keychain сохраненных данных пользователя, проводит биометрическую идентификацию, в дальнейшем в
  /// случае успеха идентификации проверяется сохраненный токен на валидность и в случае успеха пускает на основной
  /// экран.
  func checkSavedCredentials()

  /// Некая затычка нужная в случае хэндлинга различных ошибок, если случилась безобидная ошибка  при которой
  /// основной flow приложения может быть продолжен, то используется эта функция.
  func alertOKButtonTapped()
}

final class LoginViewModel: ILoginViewModel {
  
  // MARK: - Props here
  var error: Dynamic<ErrorHandlingDomain?> = Dynamic(nil)
  private let dataProvider: ILoginFlow = DataProviderFacade.shared
  private let securityService: BiometryIdentificationService = BiometryIdentificationService()
  var loginText: String?
  var passwordText: String?
  var loginSuccessful: (() -> Void)?
  var needFillTextFieldsFromSafeStorage: ((String, String) -> Void)?
  
  var authFieldsNotEmpty: Bool {
    guard let login = loginText,
          let password = passwordText else { return false }
    return login.isEmpty || password.isEmpty ? false : true
  }
  
  var loginButtonOpacityLevel: Float {
    return authFieldsNotEmpty ? 1 : 0.3
  }
  
  // MARK: - This method is for handling completion for alerts
  func alertOKButtonTapped() {
    performLoginFlow()
  }
  
  private func checkSavedToken() -> Bool {
    KeychainService.getToken() != nil
  }
  
  // MARK: - Methods here
  private func checkToken() {
    guard checkSavedToken() else {
      error.value = .noTokenStored
      return
    }
    dataProvider.checkToken { [unowned self] result in
      switch result {
      case .success:
        performLoginFlow()
      case .failure(let error):
        if error == .tokenExpired {
          self.error.value = error
        } else {
          dataProvider.setOffline()
          self.error.value = error
        }
      }
    }
  }
  
  private func performLoginFlow() {
    LockingView.lock()
    // FIXME: Лучше guard
    if let login = loginText,
       let password = passwordText {
      let signInModel = SignInModel(login: login, password: password)
      dataProvider.loginToServer(signInModel: signInModel) {[unowned self] result in
        switch result {
        case let .success(token):
          KeychainService.saveToken(token: token.token)
          KeychainService.saveLogin(login: login)
          KeychainService.savePassword(password: password)
          dataProvider.getCurrentUser {[weak self] result in
            switch result {
            case .success:
              LockingView.unlock()
              self?.loginSuccessful?()
            case .failure(let error):
              LockingView.unlock()
              self?.error.value = error
            }
          }
        case .failure(let error):
          LockingView.unlock()
          self.error.value = error
        }
      }
    }
  }
  
  func checkSavedCredentials() {
    guard checkSavedToken() else {
      error.value = .noTokenStored
      return }
    securityService.authenticateUser {[unowned self] isLoginSuccessful in
      if isLoginSuccessful {
        guard let login = KeychainService.getLogin(),
              let password = KeychainService.getPassword() else { return }
        needFillTextFieldsFromSafeStorage?(login, password)
        checkToken()
      }
    }
  }
  
  func signInButtonTapped() {
    performLoginFlow()
  }
}
