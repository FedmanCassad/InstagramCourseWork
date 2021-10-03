//
//  DateFormatter + RequredFormat.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 05.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

extension DateFormatter {
  //MARK: - Форматтер для преобразования даты приходящей с сервера в строку согласно задания
  func convertToString(date: Date) -> String {
    self.dateStyle = .medium
    self.timeStyle = .medium
    self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    self.doesRelativeDateFormatting = true
    return string(from: date)
  }
}
