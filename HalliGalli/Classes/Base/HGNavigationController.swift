//
//  HGNavigationController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class HGNavigationController: UINavigationController {
    
    deinit {
        debugPrint("\(self.classForCoder)♻️")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 侧滑返回
        self.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_return_normal"), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapBack(sender:)));
        }
        
        if #available(iOS 11, *) {
            //需要UIScrollView的实例设置contentInsetAdjustmentBehavior属性
        } else {
            viewController.automaticallyAdjustsScrollViewInsets = false
            viewController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func didTapBack(sender: UIButton) {
        self.topViewController?.view.endEditing(true)
        self.popViewController(animated: true)
    }
    
    /// 能否旋转
    override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    /// 支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    /// 初始方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    /// 隐藏状态栏动画
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? .fade
    }
}

// MARK: - UIGestureRecognizerDelegate
extension HGNavigationController: UIGestureRecognizerDelegate {
    
    /// 当控制器数量大于1时, 运行侧滑返回
    ///
    /// - Parameter gestureRecognizer: 手势
    /// - Returns: 手势允许/拒绝
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.viewControllers.count <= 1 {
            return false
        } else {
            return self.topViewController?.canEdgePanBack ?? true
        }
    }
}

extension UINavigationController {
    
    /// 获取屏幕右滑返回手势, 解决和UIScrollView的冲突
    var screenEdgsPanGestureRecognizer: UIScreenEdgePanGestureRecognizer? {
        if let value = self.view.gestureRecognizers {
            for item in value {
                if item.isKind(of: UIScreenEdgePanGestureRecognizer.classForCoder()) {
                    return (item as! UIScreenEdgePanGestureRecognizer)
                }
            }
        }
        return nil
    }
}
