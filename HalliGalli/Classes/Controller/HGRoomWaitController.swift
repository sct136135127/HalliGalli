//
//  HGRoomWaitController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  等待进入游戏界面

import UIKit

class HGRoomWaitController: UIViewController {

    /// 房间信息
    public var roomInfo: RoomInfo?
    
    /// 玩家信息
    public var userinfo: UserInfo?
    
    fileprivate lazy var startButton: UIButton = {//“开始“按钮的属性设置
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
    
    fileprivate lazy var leaveButton: UIButton = {//"离开“按钮属性设置
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

    
    fileprivate lazy var countL: UILabel = {//用一个label显示已加入人数以及等待状态（是玩家还是房主）
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = kMainThemeColor
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()

    fileprivate lazy var backgroundImageView: UIImageView = {//背景图片
        let object = UIImageView()
        object.contentMode = UIView.ContentMode.scaleAspectFill
        object.image = UIImage.imageFromColor(color: UIColor.lightGray, inSize: self.view.bounds.size)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundImageView)
        view.addSubview(startButton)
        view.addSubview(leaveButton)
        view.addSubview(countL)
        if Player.status == false {//如果当前用户身份是普通玩家，不能点击开始
            startButton.isEnabled=false
            countL.text = "已加入人数: \(roomInfo?.count ?? 0)  你是玩家，请等待房主开始游戏"
            /*我觉得应该在某个地方让server给各个普通玩家发送信息，并随时刷新。如果该房间游戏已经开始的话就进入游戏。
            if roomInfo?.isstarted==true {
                let gamecontroller=HGGamingController()
                gamecontroller.userinfo=userinfo
                navigationController?.pushViewController(gamecontroller, animated: true)
            }*/
        }else{//如果当前用户身份是房主，可以点击开始
            startButton.isEnabled=true
            countL.text = "已加入人数: \(roomInfo?.count ?? 0)  你是房主"
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
            roomInfo?.isstarted=true
            let gamecontroller=HGGamingController()
            gamecontroller.userinfo=userinfo
            gamecontroller.roominfo=roomInfo
            navigationController?.pushViewController(gamecontroller, animated: true)
        } else if sender == leaveButton {//点击离开则回到前一页
            navigationController?.popToRootViewController(animated: true)
        }
    }


    override var canEdgePanBack: Bool {
        return false
    }

}
