import Foundation
import Security

protocol IKeychainTokenManagement {
  static func saveToken(token: String)
  static func deleteToken()
  static func getToken() -> String?
  static func savePassword(password: String)
  static func saveLogin(login: String)
  static func deletePassword()
  static func deleteLogin()
  static func getLogin() -> String?
  static func getPassword() -> String?
}

final class KeychainService {
  static let server = "localhost"

  private init() {}

  @discardableResult
  static
  func save(key: String, data: Data) -> OSStatus {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: key,
                                kSecAttrServer as String: server,
                                kSecValueData as String: data]
    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }

  @discardableResult
  static
  private
  func delete(key: String) -> OSStatus {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: key,
                                kSecAttrServer as String: server]
    return SecItemDelete(query as CFDictionary)
  }

  static
  private
  func receive(key: String) -> Data? {
    let query = [
      kSecClass as String: kSecClassInternetPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: kCFBooleanTrue!,
      kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
    var dataTypeRef: AnyObject?
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    if status == noErr {
      return dataTypeRef as? Data
    } else {
      return nil
    }
  }
}

extension KeychainService: IKeychainTokenManagement {

  static
  func saveToken(token: String) {
    guard let data = token.data(using: .utf8) else { return }
    save(key: "token", data: data)
  }

  static
  func deleteToken() {
    delete(key: "token")
  }

  static
  func getToken() -> String? {
    guard let tokenData = receive(key: "token") else { return nil }
    return String(data: tokenData, encoding: .utf8)
  }

  static
  func savePassword(password: String) {
    guard let data = password.data(using: .utf8) else { return }
    save(key: "password", data: data)
  }

  static
  func saveLogin(login: String) {
    guard let data = login.data(using: .utf8) else { return }
    save(key: "login", data: data)
  }

  static
  func deletePassword() {
    delete(key: "password")
  }

  static
  func deleteLogin() {
    delete(key: "login")
  }

  static func getLogin() -> String? {
    guard let loginData = receive(key: "login") else { return nil }
    return String(data: loginData, encoding: .utf8)
  }

  static func getPassword() -> String? {
    guard let passwordData = receive(key: "password") else { return nil }
    return String(data: passwordData, encoding: .utf8)
  }

}
