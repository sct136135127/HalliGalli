//
//  HGGamingController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  游戏界面

import UIKit

//MARK:第二阶段

class HGGamingController: UIViewController {
    
    //MARK: 补充注释
    
    ///长按手势识别
    fileprivate lazy var longPress: UILongPressGestureRecognizer = {
        let object = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
        object.minimumPressDuration = 1
        
        return object
    }()
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let object = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        return object
    }()
    
    //MARK: 待完成
    /// 长按事件
    @objc fileprivate func longPressAction(sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.began ){
            //撤销牌
            
            print("撤销成功")
            //print("Longpress begin")
        }
        else if(sender.state == UIGestureRecognizer.State.ended){
            //这里不变
            //print("Longpress end")
        }
    }
    
    //MARK: 待完成
    /// 点击事件
    @objc fileprivate func tapAction(sender: UITapGestureRecognizer) {
        //请求翻牌
        
        
        //self.gamingView.Show_Card(content: <#T##String#>)
        print("翻牌成功")
    }

    /*
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
 */
    
    fileprivate lazy var answerButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
//        object.setTitle("抢答失败", for: UIControl.State.normal);
//        object.setTitle("抢答失败", for: UIControl.State.highlighted);
//        object.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
//        object.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
//        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
//        object.layer.cornerRadius = 5
//        object.layer.masksToBounds = true
        object.setImage(UIImage(named: "answer"), for: UIControl.State.normal)
        object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
        return object;
    }()
    
    ///显示剩余牌数的label
    fileprivate lazy var remainingL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = UIColor.black
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()
    
    ///显示用户名的label
    fileprivate lazy var userL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = UIColor.black
        object.text="\(player.userinfo.ID ?? "")"
        object.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return object
    }()
    
    ///显示牌的label
    fileprivate lazy var gamingView: HGGamingView = {
        let object = HGGamingView()
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.backgroundColor = UIColor(hex: 0xF7FAFA)
        return object
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //服务器发牌
        server.Arrange_Cards_By_People()
        
        //TImer监听和更新
        
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBarManager.hideStatusBar()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(gamingView)
        view.addSubview(remainingL)
        view.addSubview(answerButton)
        view.addSubview(userL)
        
        self.gamingView.addGestureRecognizer(self.longPress)
        self.gamingView.addGestureRecognizer(self.tapGesture)
        
        if player.room_num == "6" {
            remainingL.text = "剩余牌: 15"
        }else {
            remainingL.text = "剩余牌: 16"
        }
        
        gamingView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(answerButton.snp.left).offset(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
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
        
        answerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(remainingL)
            make.centerY.equalTo(gamingView.snp.centerY)
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        
        //更新牌封面
        gamingView.Show_Card(content: "00000")
    }
    
    //MARK: 待完成
    //按钮行为
    @objc fileprivate func doAction(sender: UIButton) {
//        if sender ==  successButton {//如果点击抢答成功
//            let controller = UIAlertController(title: "温馨提示", message: "\(userinfo?.Username ?? "你") 抢答成功", preferredStyle: UIAlertController.Style.alert)
//            controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in //确定抢答成功后的行为（该玩家牌数增加，并要使房间里其他玩家牌减少）
//                self.cardcnt = self.cardcnt! + 1 //实际上应该是加目前桌子上的牌或者从每人那边取一张牌
//                self.remainingL.text = "剩余牌: \(self.cardcnt ?? 0)"
//            }))
//
//            controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
//
//            }))
//            present(controller, animated: true, completion: nil)
//        } else if sender == failureButton {//如果点击抢答失败
//            let controller = UIAlertController(title: "温馨提示", message: "\(userinfo?.Username ?? "你")  抢答失败", preferredStyle: UIAlertController.Style.alert)
//            controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in //确定抢答失败后的行为
//                self.cardcnt = self.cardcnt! - 1
//                if self.cardcnt ?? 0 <= 0{//如果该玩家没牌了，判断其淘汰，进入淘汰界面
//                    self.roominfo?.count=(self.roominfo?.count)!-1 //房间玩家数减1
//                    self.navigationController?.pushViewController(HGgameoverController(), animated: true)
//                }else{
//                self.remainingL.text = "剩余牌: \(self.cardcnt ?? 0)"
//                }
//            }))
//
//            controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
//
//            }))
//            present(controller, animated: true, completion: nil)
//        }
        if sender == answerButton {
            //按下抢答按钮
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }

}
