//
//  UIView + CorneredShadow.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 31.08.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit

extension UIView
{
  func addCornerEffects(cornerRadius : CGFloat = 0,
                        fillColor : UIColor = .white,
                        shadowColor : UIColor = .clear,
                        shadowOffset : CGSize,
                        shadowOpacity : Float,
                        shadowRadius : CGFloat,
                        borderColor : UIColor,
                        borderWidth : CGFloat) {
    self.layer.cornerRadius = cornerRadius
    self.layer.shadowColor = shadowColor.cgColor
    self.layer.shadowOffset = shadowOffset
    self.layer.shadowRadius = shadowRadius
    self.layer.shadowOpacity = shadowOpacity
    self.layer.borderColor = borderColor.cgColor
    self.layer.borderWidth = borderWidth
    self.layer.backgroundColor = nil
    self.layer.backgroundColor = fillColor.cgColor
  }
}
