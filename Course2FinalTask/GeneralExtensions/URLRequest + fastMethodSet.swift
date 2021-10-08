import Foundation

extension URLRequest {
  mutating func setToPostMethod() {
    self.httpMethod = HTTPMethod.POST.rawValue
  }

  mutating func setToGetMethod() {
    self.httpMethod = HTTPMethod.GET.rawValue
  }
}

extension URLRequest {
  mutating func injectBodyPayload<T: Encodable>(payload: T) {
    self.httpBody = try? JSONEncoder().encode(payload)
  }
}
