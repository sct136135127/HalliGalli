//
//  Server.swift
//  HalliGalli
//
//  Created by JASON on 2019/12/9.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation

///继承 GCDAsyncUdpSocket 和 GCDAsyncSocket
class Server {
    
    ///房间信息
    static var room_info:RoomInfo?
    
    ///玩家信息组
    static var playerinfo_array:[UserInfo] = []
    ///服务器ip
    static var server_info:UserInfo = UserInfo()
    
    ///更新服务器网络信息
    func Update_Server_NetInfo(){
        Server.server_info.GetIPAddresses()
        Server.server_info.GetIfaNetmask()
        Server.server_info.GetIdentifier()
        
        //MARK:测试
//        print(ip_address)
//        print(identifier)
//        print(net_mask)
    }

//MARK: - 基本信息

    ///返回总人数
    static func Person_Num()->Int{
        return Server.playerinfo_array.count
    }
    
    //MARK:待完善
    ///按照人数分发牌 一人16张
    func Arrange_Cards_By_Num(){
        //let person_num = Server.Person_Num()
        
    }

//MARK: - UDP
    
    ///UDP广播
    
    ///UDP关闭

//MARK: - TCP
    
    ///TCP监听打开
    
    ///TCP监听关闭
    
    ///发送TCP Socket
}
