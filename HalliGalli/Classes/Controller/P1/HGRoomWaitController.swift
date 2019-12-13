//
//  HGRoomWaitController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  等待进入游戏界面

import UIKit

class HGRoomWaitController: UIViewController {
    
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
        object.image = UIImage.imageFromColor(color: UIColor.lightGray, inSize: self.view.bounds.size)
        return object
    }()
    
    override var preferredStatusBarStyle:UIStatusBarStyle{
        return .lightContent;
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
        
        //玩家停止接收UDP信息
        if player.status == false {
            player.Close_UDP_Receive()
        }else {
            //房主开始UDP广播房间信息
            server.Update_Server_NetInfo()
            server.Start_UDP_Broadcast()
            
            //定时广播
            control_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HGRoomWaitController.Udp_Broardcast_send), userInfo: nil, repeats: true)
        }
        
        setupUI()
    }
    
    ///发送UDP广播
    @objc func Udp_Broardcast_send(){
        server.Udp_Broardcast_send()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundImageView)
        view.addSubview(startButton)
        view.addSubview(leaveButton)
        view.addSubview(countL)
        if player.status == false {//如果当前用户身份是普通玩家，不能点击开始
            startButton.isEnabled=false
            
            //countL.text = "已加入人数: \(server.room_info?.roomCount ?? 0)  你是玩家，请等待房主开始游戏"
            //MARK: 待修改
            countL.text = "已加入人数: \(2)  你是玩家，请等待房主开始游戏"
            /*我觉得应该在某个地方让server给各个普通玩家发送信息，并随时刷新。如果该房间游戏已经开始的话就进入游戏。
            if roomInfo?.isstarted==true {
                let gamecontroller=HGGamingController()
                gamecontroller.userinfo=userinfo
                navigationController?.pushViewController(gamecontroller, animated: true)
            }*/
        }else{
            //如果当前用户身份是房主，可以点击开始
            if (server.room_info?.roomCount)! < 3{//如果房间人数小于3，不能点开始
                
                // MARK: debug结束之后修改
                startButton.isEnabled=true
                //startButton.isEnabled=false
            }else{//房间人数大于等于3可以开始
                startButton.isEnabled=true
            }
            
            countL.text = "已加入人数: \(server.room_info?.roomCount ?? 0)  你是房主"
        }
        
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
        if sender ==  startButton {//如果房主点击开始则进入游戏界面,并使其房间开始标志置1
            server.Close_UDP_Broadcast()
            
            //MARK: 待完善
            //发送游戏开始信息（TCP）
            
            
            let gamecontroller=HGGamingController()
            navigationController?.pushViewController(gamecontroller, animated: true)
        } else if sender == leaveButton {//点击离开则回到前一页
            if player.status == true{
                server.Close_UDP_Broadcast()
                
                //MARK: 待完善
                //发送房间关闭信息（TCP） 玩家接收到关闭信息时也要回到主页
                
                
            }else {
                //MARK: 待完善
                //玩家发送离开信息（TCP）
                
                
            }
            navigationController?.popToRootViewController(animated: true)
        }
    }


    override var canEdgePanBack: Bool {
        return false
    }

}
