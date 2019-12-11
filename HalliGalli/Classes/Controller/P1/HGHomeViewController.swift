//
//  HGHomeViewController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  游戏主页（起始页面）

import UIKit
import SnapKit

class HGHomeViewController: UIViewController,UITextFieldDelegate {
    
    fileprivate lazy var idtextfield:UITextField = {//输入用户名的输入框
        let object = UITextField()
        //设置边框样式为圆角矩形
        object.borderStyle = UITextField.BorderStyle.roundedRect
        object.backgroundColor=UIColor.white
        object.placeholder="请输入用户名"
        object.adjustsFontSizeToFitWidth=true
        object.minimumFontSize=10
        object.textAlignment = .left
        object.borderStyle = .bezel
        object.layer.masksToBounds=true
        object.layer.borderColor=UIColor.red.cgColor
        object.layer.borderWidth=2.0
        object.layer.cornerRadius=5.0
        object.clearButtonMode = .always
        object.becomeFirstResponder()
        object.keyboardType = .default
        object.returnKeyType = UIReturnKeyType.done
        return object
    }()
    fileprivate lazy var joinRoomButton: UIButton = { //“加入房间”按钮的属性设置
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
    
    fileprivate lazy var createRoomButton: UIButton = { //”创建房间“按钮的属性设置
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

    fileprivate lazy var backgroundImageView: UIImageView = { //背景图片
        let object = UIImageView()
        object.contentMode = UIView.ContentMode.scaleAspectFill
        object.image = UIImage.imageFromColor(color: UIColor.lightGray, inSize: self.view.bounds.size)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idtextfield.delegate = self
        Player.Update_User_NetInfo()
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
        view.addSubview(idtextfield)
        //用snap约束设置各个UI组件的布局
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        joinRoomButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(25)
            make.size.equalTo(createRoomButton)
            make.right.equalTo(view.snp.centerX).offset(-40)
            make.size.equalTo(CGSize(width: 100, height: 44))
        }
        
        createRoomButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(25)
            make.left.equalTo(view.snp.centerX).offset(40)
        }
        
        idtextfield.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {//点击软键盘上的return后的行为：更新用户名并收回键盘
        Player.userinfo.ID=textField.text ?? "user"
        textField.resignFirstResponder()
        //print("玩家名字是\(Player.userinfo.ID ?? "user")")
        return true
    }
    @objc fileprivate func doAction(sender: UIButton) {
        if sender == joinRoomButton {//如果点击的是加入房间按钮，则跳转到HGRoomList房间列表页面
            Player.status=false //用户身份转变为普通玩家
            navigationController?.pushViewController(HGRoomListController(), animated: true)
        } else if sender == createRoomButton {//如果点击的是创建房间按钮，则跳转到HGRoomWait等待界面（还需要在服务器那边更新房间列表数据源，增加一个房间以供玩家加入，不知道怎么弄）
            
            Player.status=true //用户身份转变为房主
            let roomController = HGRoomWaitController()
            navigationController?.pushViewController(roomController, animated: true)
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }
}
