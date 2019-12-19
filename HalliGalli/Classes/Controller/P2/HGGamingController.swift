//
//  HGGamingController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  游戏界面

import UIKit

//MARK:第二阶段

/// 左边动画flag
var flash_flag:Int = 0

/// 右边动画flag
var flash_flag2:Int = 0

/// server弹窗flag
var show_answer_flag:Bool = false

///弹窗flag检查
var answer_flag_timer:Timer = Timer()

class HGGamingController: UIViewController {
    
    //MARK: 记得终止
    ///更新剩余牌数的信息
    var update_card_num:Timer = Timer()
    
    ///动画flag检查
    var flash_flag_timer:Timer = Timer()
    
    fileprivate func right_pop_card(){
        UIView.transition(with: self.paidui,duration: 0.25, options: UIView.AnimationOptions.transitionCurlUp, animations: {
           }) { (flag) in
           }
    }
    
    fileprivate func right_push_card(){
        UIView.transition(with: self.paidui,duration: 0.25, options: UIView.AnimationOptions.transitionCurlDown, animations: {
        }) { (flag) in
        }
    }
    
    fileprivate func left_pop_card(){
        UIView.transition(with: self.gamingView,duration: 0.5, options: UIView.AnimationOptions.transitionCurlUp, animations: {
           self.gamingView.Show_Card(content: player.card_show!)
        }) { (flag) in
        }
    }
    
    fileprivate func left_push_card(){
        UIView.transition(with: self.gamingView,duration: 0.5, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            self.gamingView.Show_Card(content: player.card_show!)
        }) { (flag) in
            
        }
    }
    
    ///双击事件
    @objc fileprivate func doubleClickAction(sender: UITapGestureRecognizer) {
       //请求翻牌
       print("双击成功")
    }
    
    ///双击手势识别
    fileprivate lazy var doubleclick: UITapGestureRecognizer = {
        let object = UITapGestureRecognizer(target: self, action: #selector(doubleClickAction(sender:)))
        object.numberOfTapsRequired=2
        object.numberOfTouchesRequired=1
        return object
    }()
    
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
    
    /// 长按事件
    @objc fileprivate func longPressAction(sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.began ){
            //撤销牌
            player.Send_Card_Flop_Back()
            //print("撤销成功")
            //print("Longpress begin")
        }
        else if(sender.state == UIGestureRecognizer.State.ended){
            //这里不变
            //print("Longpress end")
        }
    }
    
    /// 点击事件
    @objc fileprivate func tapAction(sender: UITapGestureRecognizer) {
        //请求翻牌
        player.Send_Card_Flop()
    }
    
    ///抢答按钮设置
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
        object.imageView?.contentMode=UIView.ContentMode.scaleToFill
        object.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill;//水平方向拉伸
        object.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill;//垂直方向拉伸
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
    
    ///显示牌堆
    fileprivate lazy var paidui: UIImageView = {
        let object = UIImageView()
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.contentMode = UIView.ContentMode.scaleToFill
        object.image=UIImage(named: "paidui")
        object.backgroundColor = UIColor(hex: 0xF7FAFA)
        return object
    }()
    
    ///显示牌的label
    fileprivate lazy var gamingView: HGGamingView = {
        let object = HGGamingView()
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.layer.borderWidth=1
        object.layer.borderColor=UIColor.black.cgColor
        object.backgroundColor = UIColor(hex: 0xF7FAFA)
        return object
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //服务器发牌
        if player.status == true {
            server.Arrange_Cards_By_People()
            
            answer_flag_timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HGGamingController.Answer_Judge_Show), userInfo: nil, repeats: true)
        }
        
        if player.room_num == "6" {
            player.card_remain = "15"
        }else {
            player.card_remain = "16"
        }
        
        //TImer监听和更新
        update_card_num = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HGGamingController.Update_Card_Num), userInfo: nil, repeats: true)
        
        flash_flag_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HGGamingController.Flash_Making), userInfo: nil, repeats: true)
        
        setupUI()
    }
    
    ///判断抢答弹窗
    @objc func Answer_Judge_Show(){
        if show_answer_flag == true {
            show_answer_flag = false
            
            if server.answer_res == true {
                let controller = UIAlertController(title: "温馨提示", message: "\(server.answer_id!) 抢答成功", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                    //抢答成功
                    server.Player_Answer_Right()
                    server.answer_flag = false
                }))

                controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
                    server.answer_flag = false
                }))
                present(controller, animated: true, completion: nil)
            }else {
                let controller = UIAlertController(title: "温馨提示", message: "\(server.answer_id!) 抢答失败", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                    //抢答失败
                    server.Player_Answer_Wrong()
                    server.answer_flag = false
                }))

                controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
                    server.answer_flag = false
                }))
                present(controller, animated: true, completion: nil)
            }
            
        }
    }
    
    ///动画运行
    @objc func Flash_Making(){
        if flash_flag == 1{
            //翻牌
            left_push_card()
            right_pop_card()
        }else if flash_flag == 2{
            //撤销翻牌
            left_pop_card()
            right_push_card()
        }else if flash_flag == 3{
            //发出一张牌
            left_pop_card()
        }
        
        flash_flag = 0
    }
    
    ///更新剩余牌数 同时更新右牌堆动画
    @objc func Update_Card_Num(){
        remainingL.text = player.card_remain!
        
        if flash_flag2 == 1{
            //右牌堆收牌
            right_push_card()
        }else if flash_flag2 == 2{
            //右牌堆发牌
            right_pop_card()
        }
        
        flash_flag2 = 0
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
        view.addSubview(paidui)
        self.gamingView.addGestureRecognizer(self.longPress)
        self.gamingView.addGestureRecognizer(self.tapGesture)
        self.gamingView.addGestureRecognizer(self.doubleclick)
        tapGesture.require(toFail: doubleclick)
        
        gamingView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(answerButton.snp.left).offset(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        paidui.snp.makeConstraints{(make)in
            make.centerX.equalTo(remainingL)
            make.top.equalTo(remainingL.snp.bottom).offset(2)
            make.size.equalTo(CGSize(width: 80, height: 100))
        }
        remainingL.snp.makeConstraints { (make) in
            make.top.equalTo(5)
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
            make.centerY.equalTo(gamingView.snp.centerY).offset(20)
            make.size.equalTo(CGSize(width: 180, height: 180))
        }
        
        //更新牌封面
        gamingView.Show_Card(content: "00000")
    }
    
    //按钮行为
    @objc fileprivate func doAction(sender: UIButton) {
        if sender == answerButton {
            //按下抢答按钮
            player.Send_Ring_Calling()
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }

}

//        if sender ==  successButton {//如果点击抢答成功
//
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
