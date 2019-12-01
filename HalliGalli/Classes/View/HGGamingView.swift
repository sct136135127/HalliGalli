//
//  HGGamingView.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class HGGamingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /// 随机
    @discardableResult
    public func random() -> String {
        var result: String = ""
        for i in 0...4 {
            let random = arc4random() % 5
            result = result + "\(random)"
            if random == 0 {
                imageViews[i].image = nil
            } else {
                imageViews[i].image = UIImage(named: "image\(random)")
            }
        }
        
        return result
    }
    
    /// 图片数组
    fileprivate lazy var imageViews: [UIImageView] = {
        return [UIImageView(), UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    }()
    
    fileprivate func setupUI() {
        for item in imageViews {
            addSubview(item)
            if let index = imageViews.firstIndex(of: item) {
                if index == 0 {
                    item.snp.makeConstraints { (make) in
                        make.width.equalTo(self.snp.width).dividedBy(3)
                        make.height.equalTo(self.snp.height).dividedBy(2)
                        make.top.left.equalTo(0)
                    }
                } else if index == 1 {
                    item.snp.makeConstraints { (make) in
                        make.width.equalTo(self.snp.width).dividedBy(3)
                        make.height.equalTo(self.snp.height).dividedBy(2)
                        make.top.right.equalTo(0)
                    }
                } else if index == 2 {
                    item.snp.makeConstraints { (make) in
                        make.width.equalTo(self.snp.width).dividedBy(3)
                        make.height.equalTo(self.snp.height).dividedBy(2)
                        make.center.equalTo(self)
                    }
                } else if index == 3 {
                    item.snp.makeConstraints { (make) in
                        make.width.equalTo(self.snp.width).dividedBy(3)
                        make.height.equalTo(self.snp.height).dividedBy(2)
                        make.bottom.left.equalTo(0)
                    }
                } else if index == 4 {
                    item.snp.makeConstraints { (make) in
                        make.width.equalTo(self.snp.width).dividedBy(3)
                        make.height.equalTo(self.snp.height).dividedBy(2)
                        make.bottom.right.equalTo(0)
                    }
                }
            }
        }
    }
}
