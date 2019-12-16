//
//  StatusBarManager.swift
//  HalliGalli
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class StatusBarManager: NSObject {
    
    static private var statusBar: UIView? = {
        //横屏默认会隐藏状态栏, 崩溃请更改kShowStatusBarWhenLandScape为false
        if kShowStatusBarWhenLandScape {
            if #available(iOS 13.0, *) {
                guard let _value = UIApplication.shared.keyWindow?.windowScene?.statusBarManager else {
                    return nil
                }
                guard let _newStatusValue = _value.perform(NSSelectorFromString("createLocalStatusBar")) else {
                    return nil
                }
                guard let _newStatus = _newStatusValue.takeUnretainedValue() as? UIView else {
                    return nil
                }
                _newStatus.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: isIphoneX() ? 44 : 20)
                _newStatus.isHidden = true
                _newStatus.isUserInteractionEnabled = false
                UIApplication.shared.keyWindow?.addSubview(_newStatus)
                return _newStatus
                
            } else {
                return  UIApplication.shared.value(forKey: "statusBar") as? UIView
            }
        } else {
            return nil
        }
    }()
    
    static func showStatusBar() {
        statusBar?.isHidden = false
    }
    
    static func hideStatusBar() {
        if kShowStatusBarWhenLandScape {
            statusBar?.isHidden = true
        }
    }
    
    class func isIphoneX() -> Bool {
        return UIScreen.main.bounds.width == 896 || UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.height == 896 || UIScreen.main.bounds.height == 812
    }
    
}
