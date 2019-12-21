//
//  UIImage+Extension.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Init from UIColor
    /// - Parameter color: UIColor
    /// - Returns: UIImage
    public class func imageFromColor(color: UIColor) -> UIImage? {
        return imageFromColor(color: color, inSize: CGSize(width: 1, height: 1))
    }
    
    
    /// Init from UIColor and CGSize
    /// - Parameters:
    ///   - color: UIColor
    ///   - size: CGSize
    /// - Returns: UIImage
    public class func imageFromColor(color: UIColor, inSize size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
