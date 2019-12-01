//
//  HGGamingController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class HGGamingController: UIViewController {

    /// 玩家信息
    public var userinfo: UserInfo?
    
    //玩家手上的牌数
    public var cardcnt:Int?
    
    fileprivate lazy var successButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("抢答成功", for: UIControl.State.normal);
        object.setTitle("抢答成功", for: UIControl.State.highlighted);
        object.setTitleColor(UIColor.white, for: UIControl.State.normal)
        object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        object.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
        return object;
    }()
    
    fileprivate lazy var failureButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("抢答失败", for: UIControl.State.normal);
        object.setTitle("抢答失败", for: UIControl.State.highlighted);
        object.setTitleColor(UIColor.white, for: UIControl.State.normal)
        object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        object.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
        return object;
    }()
    
    
    fileprivate lazy var remainingL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = UIColor.black
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()
    
    fileprivate lazy var userL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = UIColor.black
        object.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return object
    }()
    
    fileprivate lazy var gamingView: HGGamingView = {
        let object = HGGamingView()
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.backgroundColor = UIColor(hex: 0xCCCCCC)
        return object
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardcnt=16
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(gamingView)
        view.addSubview(remainingL)
        view.addSubview(successButton)
        view.addSubview(failureButton)
        view.addSubview(userL)
        
        remainingL.text = "剩余牌: \(cardcnt ?? 0)"
        userL.text = userinfo?.Username
        
        gamingView.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.equalTo(gamingView.snp.height).multipliedBy(1.5)
        }
        
        remainingL.snp.makeConstraints { (make) in
            make.top.equalTo(gamingView).offset(8)
            make.left.equalTo(gamingView.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        
        userL.snp.makeConstraints { (make) in
            make.bottom.equalTo(gamingView).offset(-8)
            make.left.equalTo(gamingView.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        
        successButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(remainingL)
            make.centerY.equalTo(gamingView.snp.centerY).offset(-32)
            make.size.equalTo(CGSize(width: 120, height: 44))
        }
        
        failureButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(remainingL)
            make.centerY.equalTo(gamingView.snp.centerY).offset(32)
            make.size.equalTo(CGSize(width: 120, height: 44))
        }
        print(gamingView.random())
    }
    
    @objc fileprivate func doAction(sender: UIButton) {
        if sender ==  successButton {
            let controller = UIAlertController(title: "温馨提示", message: "\(userinfo?.Username ?? "你") 抢答成功", preferredStyle: UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                self.cardcnt = self.cardcnt! + 1 //实际上应该是加目前桌子上的牌或者从每人那边取一张牌
                self.remainingL.text = "剩余牌: \(self.cardcnt ?? 0)"
            }))
            
            controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
                
            }))
            present(controller, animated: true, completion: nil)
        } else if sender == failureButton {
            let controller = UIAlertController(title: "温馨提示", message: "\(userinfo?.Username ?? "你")  抢答失败", preferredStyle: UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                self.cardcnt = self.cardcnt! - 1
                if self.cardcnt ?? 0 <= 0{
                    self.navigationController?.pushViewController(HGgameoverController(), animated: true)
                }else{
                self.remainingL.text = "剩余牌: \(self.cardcnt ?? 0)"
                }
            }))
            
            controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
                
            }))
            present(controller, animated: true, completion: nil)
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }
    
    /// 点击时随机
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view?.isDescendant(of: gamingView) ?? false {
            print(gamingView.random())
        }
    }

}
