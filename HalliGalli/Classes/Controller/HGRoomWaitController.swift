//
//  HGRoomWaitController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class HGRoomWaitController: UIViewController {

    /// 房间信息
    public var roomInfo: RoomInfo?
    /// 玩家信息
    public var userinfo: UserInfo?
    
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

    
    fileprivate lazy var countL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = kMainThemeColor
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()

    fileprivate lazy var backgroundImageView: UIImageView = {
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
        if userinfo?.status==0 {
            startButton.isEnabled=false
            countL.text = "已加入人数: \(roomInfo?.count ?? 0)  你是玩家，请等待房主开始游戏"
        }else if userinfo?.status==1{
            startButton.isEnabled=true
            countL.text = "已加入人数: \(roomInfo?.count ?? 0)  你是房主"
        }
        
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
    
    @objc fileprivate func doAction(sender: UIButton) {
        if sender ==  startButton {
            let gamecontroller=HGGamingController()
            gamecontroller.userinfo=userinfo
            navigationController?.pushViewController(gamecontroller, animated: true)
        } else if sender == leaveButton {
            navigationController?.popToRootViewController(animated: true)
        }
    }


    override var canEdgePanBack: Bool {
        return false
    }

}
