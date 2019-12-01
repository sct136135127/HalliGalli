//
//  HGgameoverController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import UIKit

class HGgameoverController:UIViewController{
    
    fileprivate lazy var createRoomButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("你已被淘汰，单击此处返回游戏起始页", for: UIControl.State.normal);
        object.setTitle("你已被淘汰，单击此处返回游戏起始页", for: UIControl.State.highlighted);
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
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundImageView)
        view.addSubview(createRoomButton)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        
        createRoomButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc fileprivate func doAction(sender: UIButton) {
        if sender == createRoomButton {
            let roomController = HGHomeViewController()
            roomController.userinfo=UserInfo(Username: "孙楚涛", status: 1)
            navigationController?.pushViewController(roomController, animated: true)
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }
}
