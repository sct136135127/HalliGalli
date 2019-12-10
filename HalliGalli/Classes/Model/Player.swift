//
//  Player.swift
//  HalliGalli
//
//  Created by JASON on 2019/12/9.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

///继承 GCDAsyncUdpSocket 和 GCDAsyncSocket
class Player {
    
    /// 玩家信息
    static var userinfo:UserInfo = UserInfo()
    /// true为房主 false为普通玩家
    static var status:Bool?
    /// 服务器地址 (类型更改)
    static var server_ip: String?
    /// 房间列表信息
    static var room_list:[RoomInfo] = []
    
    ///获得本机基本网络信息
    ///后期考虑一段时间更新一次
    ///提醒打开wifi
    static func Update_User_NetInfo(){
        Player.userinfo.GetIPAddresses()
        Player.userinfo.GetIfaNetmask()
        Player.userinfo.GetIdentifier()
        
        //MARK:测试
//        print(ip_address)
//        print(identifier)
//        print(net_mask)
    }

//MARK: - UDP
    ///UDP监听打开
    
    ///UDP监听关闭
   
//MARK: - TCP
    
    ///TCP监听打开
    
    ///TCP监听关闭
    
    ///发送TCP Socket
    
}
