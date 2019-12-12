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
    ///提醒打开wifi
    func Update_User_NetInfo(){
        userinfo.GetIPNetmask()
        userinfo.GetIdentifier()
        
        //MARK:测试
//        print(userinfo.ip_address)
//        print(userinfo.identifier)
//        print(userinfo.net_mask)
        
    }
    
    ///按照时间差更新房间列表
    func Update_Roomlist_Info(){
        //对超时的房间进行remove处理
        var record:[Int] = []
        
        for i in 0..<room_list.count {
            let temp_room_time = room_list[i].rev_time!
            let timeInterval = -1 * temp_room_time.timeIntervalSinceNow
            
            //失联超过1s
            if timeInterval > 1 {
                record.append(i)
            }
        }
        
        //可能出错
        for i in 0..<record.count {
            room_list.remove(at: record[i] - i)
        }
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
    
    ///UDP接收
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        let msg:String = String(data: data,encoding: .utf8) ?? "error/error/error/error"
        
        //判断是否为指定的接收到的UDP（前缀判断）
        if msg.split(separator: "/")[0] == "HG"{
            //更新roominfo的信息和接收时间
            let temp_time:Date = Date()
            
            let temp_roomID = msg.split(separator: "/")[1]
            let temp_roomAddress = msg.split(separator: "/")[2]
            let temp_roomNumCount = msg.split(separator: "/")[3]
            
            var find_flag = false
            for room in room_list {
                if room.roomAddress! == String(temp_roomAddress) {
                    find_flag = true
                    room.roomID = String(temp_roomID)
                    room.roomCount = Int(String(temp_roomNumCount)) ?? 0
                    room.rev_time = temp_time
                }
            }
            
            if find_flag == false {
                room_list.append(RoomInfo(roomID: String(temp_roomID), roomAddress: String(temp_roomAddress), roomCount: Int(String(temp_roomNumCount)) ?? 0))
            }
        }
        
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
