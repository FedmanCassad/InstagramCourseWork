import Foundation

extension URL {
  func getPNGData(completion: @escaping ((Result<Data?, Error>) -> Void)) {
    URLSession(configuration: .default).dataTask(with: self) {data, _, error in
      if let error = error {
        completion(.failure(error))
      }
      guard
        let data = data
      else { return }
      completion(.success(data))
    }
  }
}
