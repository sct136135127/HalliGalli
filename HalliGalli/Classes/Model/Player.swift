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
class Player: NSObject, GCDAsyncUdpSocketDelegate{
    
    /// 玩家信息
    var userinfo:UserInfo = UserInfo()
    /// true为房主 false为普通玩家
    var status:Bool?
    /// 服务器地址 (类型更改)
    var server_ip: String?
    /// 房间列表信息
    var room_list:[RoomInfo] = []
    ///UDP socket
    var udp_socket:GCDAsyncUdpSocket?
    ///UDP error
    var udp_error:String?
    
//MARK: - 其他
    ///获得本机基本网络信息
    ///后期考虑一段时间更新一次
    ///提醒打开wifi
    func Update_User_NetInfo(){
        userinfo.GetIPNetmask()
        userinfo.GetIdentifier()
        
        //MARK:测试
//        print(userinfo.ip_address)
//        print(userinfo.identifier)
//        print(userinfo.net_mask)
        
    }
    
    //MARK: 待完善
    ///按照时间差更新房间列表
    func Update_Roomlist_Info(){
        //对超时的房间进行remove处理
    }

//MARK: - UDP
    ///UDP监听打开
    func Start_UDP_Receive(){
        //UDP初始化
        udp_socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do{
            try udp_socket?.bind(toPort: 2333, interface: udp_error)
        }catch{
            if let _ = udp_error{
                print(udp_error!)
            }
        }
        
        do{
            try udp_socket?.beginReceiving()
        }catch{
            print("start receiving fail")
        }
        print("开始监听UDP")
    }
    
    ///UDP监听关闭
    func Close_UDP_Receive(){
        udp_socket?.close()
        print("监听UDP关闭")
    }
    
    //MARK: 待完善
    ///UDP接收
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        print(String(data: data,encoding: .utf8) ?? "error","\n",String(data: address,encoding: .utf8) ?? "error")
        
        //判断是否为指定的接收到的UDP（前缀判断）
        
        //更新roominfo的信息和接收时间
        
    }
    
    ///UDP关闭
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        print("udp关闭成功")
    }
   
//MARK: - TCP
    
    ///TCP监听打开
    
    ///TCP监听关闭
    
    ///发送TCP Socket
    
}
