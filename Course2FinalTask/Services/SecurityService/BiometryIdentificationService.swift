import LocalAuthentication
import UIKit

class BiometryIdentificationService {
  
  private func userHasToken () -> Bool {
    return KeychainService.getToken() != nil
  }
  
  func authenticateUser(completion: @escaping (Bool) -> Void) {
    guard userHasToken() else {
      completion(false)
      return
    }
    let authenticationContext = LAContext()
    authenticationContext.localizedReason = "Use for fast and safe authentication in your app"
    authenticationContext.localizedCancelTitle = "Cancel"
    authenticationContext.localizedFallbackTitle = "Enter password"
    authenticationContext.touchIDAuthenticationAllowableReuseDuration = 100
    let reason = "Fast and safe authentication in your app"
    var authError: NSError?
    if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
      authenticationContext
        .evaluatePolicy(
          .deviceOwnerAuthenticationWithBiometrics,
          localizedReason: reason
        ) { success, evaluateError in
          DispatchQueue.main.async {
            if success {
              completion(true)
            } else {
              if let error = evaluateError {
                print(error.localizedDescription)
                completion(false)
              }
            }
          }
        }
    } else {
      if let error = authError {
        print(error.localizedDescription)
      }
      completion(false)
    }
  }
}
