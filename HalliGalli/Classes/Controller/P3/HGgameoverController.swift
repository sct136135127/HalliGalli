//
//  HGgameoverController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  淘汰界面

import UIKit

//MARK: 第三阶段 未使用
class HGgameoverController:UIViewController{
    
    ///弹窗的属性样式
        fileprivate lazy var contentView: UIView = {
            let object = UIView()
            object.backgroundColor = UIColor.lightText
            object.layer.cornerRadius = 5
            object.layer.masksToBounds = true
            return object
        }()
        ///"离开“按钮属性设置
        /*fileprivate lazy var leaveButton: UIButton = {
            let object = UIButton(type: UIButton.ButtonType.custom)
            object.setTitle("离开", for: UIControl.State.normal);
            object.setTitle("离开", for: UIControl.State.highlighted);
            object.setTitleColor(UIColor.white, for: UIControl.State.normal)
            object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
            object.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
            object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
            object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
            object.layer.cornerRadius = 5
            object.layer.masksToBounds = true
            object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
            return object;
        }()*/
    
        ///弹窗的label文字（字体内容）
        fileprivate lazy var contentLabel: UILabel = {
            let object = UILabel()
            object.textColor = UIColor.red
            object.font = UIFont.systemFont(ofSize:100, weight: UIFont.Weight(rawValue: 5))
            object.textAlignment = .center
            object.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
            object.numberOfLines = 0
            
            object.text = """
            Game
            Over！
            """
            return object
        }()
    fileprivate lazy var leaveLabel: UILabel = {
        let object = UILabel()
        object.textColor = UIColor.blue
        object.font = UIFont.systemFont(ofSize:25, weight: UIFont.Weight(rawValue: 2))
        object.textAlignment = .center
        object.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        object.numberOfLines = 0
        
        object.text = "房主请停留，其他玩家点击右下角退出房间"
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
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.modalTransitionStyle = .flipHorizontal
            self.modalPresentationStyle = .custom
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view .addSubview(contentView)
            //contentView.addSubview(leaveButton)
            contentView.addSubview(contentLabel)
            contentView.addSubview(leaveLabel)
            contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 500, height: 400))
                
            }
            contentLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-50)
                make.size.equalTo(CGSize(width: 499, height: 300))
            }
            leaveLabel.snp.makeConstraints{(make)in
                make.centerX.equalToSuperview()
                make.top.equalTo(contentLabel.snp.bottom)

            }
            /*leaveButton.snp.makeConstraints{(make)in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(10)
            }*/
        }
    /*@objc fileprivate func doAction(sender: UIButton) {
        if sender == leaveButton{
            navigationController?.popToRootViewController(animated: true);
        }
    }*/
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            if !(touches.first?.view?.isDescendant(of: self.contentView) ?? true) {
                dismiss(animated: true, completion: nil)
                //navigationController?.popToRootViewController(animated: true);
            }
        }
    }
