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
    
    ///更新剩余牌数的信息
    var update_card_num:Timer = Timer()
    
    ///动画flag检查
    var flash_flag_timer:Timer = Timer()
    
    ///检查玩家游戏状态
    var player_game_status_timer:Timer = Timer()
    
    ///检查游戏结束状态
    var game_status_timer:Timer = Timer()
    
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
        UIView.transition(with: self.gamingView,duration: 0.4, options: UIView.AnimationOptions.transitionCurlUp, animations: {
           self.gamingView.Show_Card(content: player.card_show!)
        }) { (flag) in
        }
    }
    
    fileprivate func left_push_card(){
        UIView.transition(with: self.gamingView,duration: 0.4, options: UIView.AnimationOptions.transitionCurlDown, animations: {
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
    
    ///测试淘汰按钮
//    fileprivate lazy var gameovertest: UIButton = {
//        let object = UIButton(type: UIButton.ButtonType.custom)
//            object.setTitle("测试淘汰", for: UIControl.State.normal);
//            object.setTitle("测试淘汰", for: UIControl.State.highlighted);
//            object.setTitleColor(UIColor.white, for: UIControl.State.normal)
//            object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
//            object.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//            object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
//            object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
//            object.layer.cornerRadius = 5
//            object.layer.masksToBounds = true
//            object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
//            return object;
//    }()
    
    ///“退出房间”按钮
    fileprivate lazy var leaveroom: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
            object.setTitle("退出房间", for: UIControl.State.normal);
            object.setTitle("退出房间", for: UIControl.State.highlighted);
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
    
    ///抢答按钮设置
    fileprivate lazy var answerButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
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

    //结束后弹出的view
    fileprivate lazy var contentView: UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor(hex: 0xF7FAFA)
        object.layer.cornerRadius = 5
        object.layer.borderWidth=1
        object.layer.borderColor=UIColor.black.cgColor

        object.layer.masksToBounds = true
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        player.player_game_status = 0
        
        //服务器发牌
        if player.status == true {
            server.Arrange_Cards_By_People()
            server.game_end_flag = false
            
            answer_flag_timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HGGamingController.Answer_Judge_Show), userInfo: nil, repeats: true)
            
            game_status_timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HGGamingController.Game_Status), userInfo: nil, repeats: true)
        }
        
        if player.room_num == "6" {
            player.card_remain = "15"
        }else {
            player.card_remain = "16"
        }
        
        //TImer监听和更新
        update_card_num = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HGGamingController.Update_Card_Num), userInfo: nil, repeats: true)
        
        flash_flag_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HGGamingController.Flash_Making), userInfo: nil, repeats: true)
        
        player_game_status_timer = Timer.scheduledTimer(timeInterval: 0.5,target: self,selector: #selector(HGGamingController.Player_Game_Status),userInfo: nil,repeats: true)
        
        setupUI()
    }
    
    ///判断玩家游戏是否结束
    @objc func Player_Game_Status(){
        if player.player_game_status == -1 || player.player_game_status == 1{
            //游戏结束界面
            
            ///删除显示牌的gamingview，禁用抢答按钮
            self.gamingView.removeFromSuperview()
            self.answerButton.isEnabled=false
            ///通过动画显示淘汰（OUT）或者胜利（WIN）的效果变化，并重新布局（其他组件保持不变）
            UIView.transition(with: self.view,duration: 1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.view.addSubview(self.contentView)
                self.contentView.snp.makeConstraints { (make) in
                    make.left.equalTo(30)
                    make.right.equalTo(self.answerButton.snp.left).offset(-10)
                    make.top.equalTo(10)
                    make.bottom.equalTo(-10)
                }
                self.paidui.snp.makeConstraints{(make)in
                    make.centerX.equalTo(self.remainingL)
                    make.top.equalTo(self.remainingL.snp.bottom).offset(2)
                    make.size.equalTo(CGSize(width: 80, height: 100))
                }
                self.remainingL.snp.makeConstraints { (make) in
                    make.top.equalTo(5)
                    make.left.equalTo(self.contentView.snp.right).offset(20)
                    make.right.equalTo(-20)
                }
                
                self.userL.snp.makeConstraints { (make) in
                    make.bottom.equalTo(self.contentView).offset(-8)
                    make.left.equalTo(self.contentView.snp.right).offset(20)
                    make.right.equalTo(-20)
                }
    //                self.gameovertest.snp.makeConstraints{ (make) in
    //                    make.bottom.equalTo(self.userL.snp.top)
    //                    make.left.equalTo(self.contentView.snp.right).offset(40)
    //                    make.width.equalTo(100)
    //                    make.right.equalTo(-40)
    //                }
                self.answerButton.snp.makeConstraints { (make) in
                    make.centerX.equalTo(self.remainingL)
                    make.centerY.equalTo(self.contentView.snp.centerY).offset(20)
                    make.size.equalTo(CGSize(width: 180, height: 180))
                }
                //self.gameovertest.removeFromSuperview()
                self.view.addSubview(self.leaveroom)
                self.leaveroom.snp.makeConstraints{ (make) in
                    make.bottom.equalTo(self.userL.snp.top)
                    make.left.equalTo(self.contentView.snp.right).offset(40)
                    make.width.equalTo(100)
                    make.right.equalTo(-40)
                }
                self.contentView.contentMode = UIView.ContentMode.scaleAspectFit
                if player.player_game_status == -1 {
                    self.contentView.image=UIImage(named: "out")
                    print("HG玩家淘汰")
                }else if player.player_game_status == 1{
                    self.contentView.image=UIImage(named: "win")
                    print("HG玩家胜利")
                }
               }) { (flag) in
            }
            
            if player.status! == true {
                self.leaveroom.isEnabled = false
            }else {
                self.leaveroom.isEnabled = true
            }
            
            player_game_status_timer.invalidate()
        }
    }
    
    @objc func Game_Status(){
        if server.game_end_flag == true {
             self.leaveroom.isEnabled = true
        }
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
        //view.addSubview(gameovertest)
        
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
//        gameovertest.snp.makeConstraints{ (make) in
//            make.bottom.equalTo(userL.snp.top)
//            make.left.equalTo(gamingView.snp.right).offset(40)
//            make.width.equalTo(100)
//            make.right.equalTo(-40)
//        }
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
        else if sender == self.leaveroom{//点击退出房间以后返回主页
            player.End_Connect()
            update_card_num.invalidate()
            flash_flag_timer.invalidate()
            if player.status == true {
                answer_flag_timer.invalidate()
                game_status_timer.invalidate()
            }
            navigationController?.popToRootViewController(animated: true);
        }
        
    }

    override var canEdgePanBack: Bool {
        return false
    }
    /// 移除所有子控件
    func removeAllSubViews(){
        if view.subviews.count>0{
            view.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}
