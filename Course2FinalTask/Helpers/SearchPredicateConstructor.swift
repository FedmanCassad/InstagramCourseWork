//
//  SearchPredicateConstructor.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 26.09.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

class SearchPredicateConstructor {

 class func getPredicates(by fields: [String: Any]) -> [NSPredicate] {
    var predicates = [NSPredicate]()
    for (key, value) in fields where key != "comparisonSign" {
      if let value = value as? Bool {
        let predicate = NSPredicate(format: "\(key) == %@", NSNumber(booleanLiteral: value))
        predicates.append(predicate)
      }
      if let value = value as? String {
        if let value = Int16(value), let sign = fields["comparisonSign"] as? String  {
          let predicate = NSPredicate(format: "\(key) \(sign) %i", value)
          predicates.append(predicate)
        }
        else {
          let predicate = NSPredicate(format: "\(key) CONTAINS[c] %@", value)
          predicates.append(predicate)
        }
      }
    }
    return predicates
  }

  class func getUserPredicate(by userID: User.ID) -> [NSPredicate] {
    getPredicates(by: ["id": userID])
  }
  
}
