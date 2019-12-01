//
//  UIColor+Extension.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Init from UInt64 e.g. 0x333333
    ///
    /// - Parameters:
    ///   - hex: UInt64
    ///   - alpha: alpha
    convenience init(hex: UInt64, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            G: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            B: CGFloat(hex & 0x0000FF) / 255.0
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    /// 随机颜色
    ///
    /// - Returns: UIColor
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

}
