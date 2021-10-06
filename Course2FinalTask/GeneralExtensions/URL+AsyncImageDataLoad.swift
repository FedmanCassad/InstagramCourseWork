//
//  URL+SyncImageDataLoad.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 23.09.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

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
