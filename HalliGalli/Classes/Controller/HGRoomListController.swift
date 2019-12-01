//
//  HGRoomListController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class HGRoomListController: UIViewController {

    /// 数据源
    public var dataSource: [RoomInfo] = []
    /// 玩家信息
    public var userinfo: UserInfo?
    
    /// 选中的房间
    fileprivate var selectedRoomInfo: RoomInfo?
    
    /// TableView
    fileprivate lazy var tableView: UITableView = {
        let object = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        object.delegate = self
        object.dataSource = self
        object.tableFooterView = UIView()
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        return object
    }()
    
    fileprivate lazy var joinButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("加入", for: UIControl.State.normal);
        object.setTitle("加入", for: UIControl.State.highlighted);
        object.setTitleColor(UIColor.white, for: UIControl.State.normal)
        object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        object.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
        object.isEnabled = false
        return object;
    }()
    
    fileprivate lazy var listTitleL: UILabel = {
        let object = UILabel()
        object.text = "房间列表"
        object.textAlignment = .center
        object.textColor = kMainThemeColor
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("取消", for: UIControl.State.normal);
        object.setTitle("取消", for: UIControl.State.highlighted);
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
        dataSource = [
            RoomInfo(roomID: 1, count: 121),
            RoomInfo(roomID: 2, count: 122),
            RoomInfo(roomID: 3, count: 123),
            RoomInfo(roomID: 4, count: 124),
            RoomInfo(roomID: 5, count: 125),
            RoomInfo(roomID: 6, count: 126)]
        setupUI()
    }

    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundImageView)
        view.addSubview(listTitleL)
        view.addSubview(tableView)
        view.addSubview(joinButton)
        view.addSubview(cancelButton)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        listTitleL.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(tableView)
            make.centerX.equalTo(view)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(listTitleL.snp.bottom).offset(5)
            make.width.equalTo(360)
            make.bottom.equalTo(-40)
            make.centerX.equalTo(view).offset(-50)
        }
        
        joinButton.snp.makeConstraints { (make) in
            make.left.equalTo(tableView.snp.right).offset(40)
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.centerY.equalTo(tableView.snp.centerY).offset(-30)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(tableView.snp.right).offset(40)
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.centerY.equalTo(tableView.snp.centerY).offset(30)
        }
    }
    
    @objc fileprivate func doAction(sender: UIButton) {
        if sender ==  joinButton {
            let roomController = HGRoomWaitController()
            roomController.userinfo=userinfo
            roomController.roomInfo = selectedRoomInfo
            navigationController?.pushViewController(roomController, animated: true)
        } else if sender == cancelButton {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override var canEdgePanBack: Bool {
        return false
    }
}


extension HGRoomListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "UITableViewCell")
        }
        let currentInfo = dataSource[indexPath.row]
        cell.textLabel?.text = "房间\(currentInfo.roomID ?? 1)"
        if selectedRoomInfo != nil && currentInfo.roomID == selectedRoomInfo?.roomID {
            cell.textLabel?.textColor = kMainThemeColor
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoomInfo = dataSource[indexPath.row]
        joinButton.isEnabled = true
        tableView.reloadData()
    }
}
