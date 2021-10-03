//
//  UIImageView + AnimatingAppearance.swift
//  Course2FinalTask
//
//  Created by Vladimir Banushkin on 18.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit

extension UIImageView {

	func appearingAnimated() {
		let animator = CAKeyframeAnimation(keyPath: "opacity")
		animator.values = [0,1,1,0]
		animator.keyTimes  = [0, 0.1, 0.2, 0.3]
		animator.duration = 3
		animator.isAdditive = true
		animator.timingFunction = CAMediaTimingFunction(controlPoints: 0.15, 1, 0.85, 0)
		layer.add(animator, forKey: "opacity")
  }
}
