//
//  HGRoomWaitController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  等待进入游戏界面

import UIKit

///房间当前状态
var room_status:Int?

class HGRoomWaitController: UIViewController {

    /// UDP广播时间控制器
    var control_timer = Timer()
    ///更新label的时间控制器
    var label_timer = Timer()
    ///查看房间状态的时间控制器
    var room_timer = Timer()
    
    ///“开始“按钮的属性设置
    fileprivate lazy var startButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("开始", for: UIControl.State.normal);
        object.setTitle("开始", for: UIControl.State.highlighted);
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
    
    ///"离开“按钮属性设置
    fileprivate lazy var leaveButton: UIButton = {
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
    }()

    ///用一个label显示已加入人数以及等待状态（是玩家还是房主）
    fileprivate lazy var countL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = kMainThemeColor
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()

    //背景图片
    fileprivate lazy var backgroundImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = UIView.ContentMode.scaleAspectFill
        object.image = UIImage.imageFromColor(color: UIColor.white, inSize: self.view.bounds.size)
        return object
    }()
    
    ///状态栏bar的文字样式
    override var preferredStatusBarStyle:UIStatusBarStyle{
        return .default;
    }
    
    override var prefersStatusBarHidden:Bool{
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBarManager.showStatusBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        room_status = 0
        
        //玩家停止接收UDP信息
        if player.status == false {
            player.Close_UDP_Receive()
        }else {
            //房主开始UDP广播房间信息
            server.Update_Server_NetInfo()
            server.Start_UDP_Broadcast()
            
            //定时UDP广播房间信息
            control_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HGRoomWaitController.Udp_Broardcast_send), userInfo: nil, repeats: true)
        }
        
        //定时更新label
        label_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HGRoomWaitController.Update_Room_Label), userInfo: nil, repeats: true)
        
        //定时查看房间状态
        room_timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HGRoomWaitController.Check_Game_Flag), userInfo: nil, repeats: true)
        
        setupUI()
    }
    
    ///更新房间人数标签
    @objc func Update_Room_Label(){
        if player.status == false {
            countL.text = "已加入人数: \(player.room_num ?? "wrong")  你是玩家，请等待房主开始游戏"
        }else{
            countL.text = "已加入人数: \(player.room_num ?? "wrong")  你是房主，请等待玩家加入"
            if player.room_num != nil {
                if Int(player.room_num!)! >= 3 {
                    startButton.isEnabled = true
                }else {
                    startButton.isEnabled = false
                }
            }
        }
        
    }
    
    ///发送UDP广播
    @objc func Udp_Broardcast_send(){
        server.Udp_Broardcast_send()
    }
    
    ///检查是否游戏开始 -1为房主退出 0为未开始 1为游戏开始
    @objc func Check_Game_Flag(){
        if room_status == 0 {
            
        }else if room_status == -1 {
            //房主退出 房间解散 or 玩家退出
            room_timer.invalidate()
            label_timer.invalidate()
            
            //回到主界面
            navigationController?.popToRootViewController(animated: true)
        }else if room_status == 1 {
            //游戏准备开始
            room_timer.invalidate()
            label_timer.invalidate()
            
            //进入游戏界面
            let gamecontroller=HGGamingController()
            navigationController?.pushViewController(gamecontroller, animated: true)
        }
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundImageView)
        view.addSubview(startButton)
        view.addSubview(leaveButton)
        view.addSubview(countL)
        
        startButton.isEnabled=false
        
        //snp布置布局
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(leaveButton)
            make.right.equalTo(view.snp.centerX).offset(-40)
            make.size.equalTo(CGSize(width: 100, height: 44))
        }
        
        leaveButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(view.snp.centerX).offset(40)
        }

        countL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leaveButton.snp.bottom).offset(30)
        }
    }
    
    //按钮行为
    @objc fileprivate func doAction(sender: UIButton) {
        if sender ==  startButton {
            //房主点击开始
            //停止UDP广播房间信息
            control_timer.invalidate()
            server.Close_UDP_Broadcast()
            
            //发送游戏开始信息（TCP）所有人room_status置 1
            server.Send_Game_Start()
        } else if sender == leaveButton {//点击离开则回到前一页
            if player.status == true{
                //房主离开房间
                //停止UDP广播房间信息
                control_timer.invalidate()
                server.Close_UDP_Broadcast()
                
                server.Send_Room_Close()
                //房主与所有人断连
                server.Stop_ALL_TCP()
                player.End_Connect()
                room_status = -1
            }else {
                //玩家离开房间
                //断开TCP连接 room_status置 -1
                player.Send_Player_Leave()
                player.End_Connect()
                room_status = -1
            }
            
        }
    }


    override var canEdgePanBack: Bool {
        return false
    }

}
