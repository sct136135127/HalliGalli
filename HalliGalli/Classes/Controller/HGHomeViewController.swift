//
//  HGHomeViewController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit
import SnapKit

class HGHomeViewController: UIViewController {
    
    /// 玩家信息
    public var userinfo: UserInfo?
    
    fileprivate lazy var joinRoomButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("加入房间", for: UIControl.State.normal);
        object.setTitle("加入房间", for: UIControl.State.highlighted);
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
    
    fileprivate lazy var createRoomButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("创建房间", for: UIControl.State.normal);
        object.setTitle("创建房间", for: UIControl.State.highlighted);
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

    fileprivate lazy var backgroundImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = UIView.ContentMode.scaleAspectFill
        object.image = UIImage.imageFromColor(color: UIColor.lightGray, inSize: self.view.bounds.size)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userinfo=UserInfo(Username: "孙楚涛", status: 0)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundImageView)
        view.addSubview(joinRoomButton)
        view.addSubview(createRoomButton)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        joinRoomButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(createRoomButton)
            make.right.equalTo(view.snp.centerX).offset(-40)
            make.size.equalTo(CGSize(width: 100, height: 44))
        }
        
        createRoomButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(view.snp.centerX).offset(40)
        }
    }
    
    @objc fileprivate func doAction(sender: UIButton) {
        if sender == joinRoomButton {
            navigationController?.pushViewController(HGRoomListController(), animated: true)
        } else if sender == createRoomButton {
            userinfo?.status=1
            let roomController = HGRoomWaitController()
            roomController.userinfo=UserInfo(Username: "孙楚涛", status: 1)
            roomController.roomInfo = RoomInfo(roomID: 10, count: 1)
            navigationController?.pushViewController(roomController, animated: true)
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }
}
