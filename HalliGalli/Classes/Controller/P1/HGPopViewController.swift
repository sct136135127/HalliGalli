//
//  HGPopViewController.swift
//  HalliGalli
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  游戏规则的弹窗

import UIKit

class HGPopViewController: UIViewController {

    ///弹窗的属性样式
    fileprivate lazy var contentView: UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.white
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        return object
    }()
    
    ///弹窗的label文字（字体内容）
    fileprivate lazy var contentLabel: UILabel = {
        let object = UILabel()
        object.textColor = UIColor.lightGray
        object.font = UIFont.systemFont(ofSize: 15)
        object.numberOfLines = 0
        object.text = "第三方绝对是减肥多少积分冻死了福建水电费绝对是减肥多少积分几点睡了房间里的士速递反倒是经历了打扫房间的解放军第十六届范德萨解放路"
        return object
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        didFinishInit()
    }
    
//    init() {
//        super.init()
//        self.didFinishInit()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didFinishInit()
    }
    
    fileprivate func didFinishInit() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view .addSubview(contentView)
        contentView.addSubview(contentLabel)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !(touches.first?.view?.isDescendant(of: self.contentView) ?? true) {
            dismiss(animated: true, completion: nil)
        }
    }
}
