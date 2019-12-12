//
//  Server.swift
//  HalliGalli
//
//  Created by JASON on 2019/12/9.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

///继承 GCDAsyncUdpSocket 和 GCDAsyncSocket
class Server: NSObject, GCDAsyncUdpSocketDelegate {
    
    ///房间信息
    var room_info:RoomInfo?
    
    ///玩家信息组
    var playerinfo_array:[UserInfo] = []
    ///服务器ip
    var server_info:UserInfo = UserInfo()
    ///UDP socket
    var udp_socket:GCDAsyncUdpSocket?
    ///UDP error
    var udp_error:String?
    ///UDP 广播地址
    var udp_broadcast_address:String = "255.255.255.255"
    
    ///更新服务器网络信息
    func Update_Server_NetInfo(){
        server_info = player.userinfo
        
        //MARK:测试
//        print(userinfo.ip_address)
//        print(userinfo.identifier)
//        print(userinfo.net_mask)
        
        //添加房主信息 更新房间信息
        playerinfo_array.append(player.userinfo)
        room_info = RoomInfo(roomID: server_info.ID ?? "error", roomAddress: server_info.ip_address ?? "error", roomCount: 1)
        //更新局域网广播地址
        Udp_broadcast_address()
    }
    
    ///计算UDP广播地址
    func Udp_broadcast_address(){
        //let ip = server_info.ip_address
        //let netmask = server_info.net_mask
        
        //MARK: 待检查和修改
        //默认255.255.255.255 如果测试成功则不需要通过ip和netmask计算
        print("broadcast: \(udp_broadcast_address)")
    }

//MARK: - 基本信息

    ///返回总人数
    func Person_Num()->Int{
        return self.playerinfo_array.count
    }
    
    //MARK:待完善
    ///按照人数分发牌 一人16张 6人则每人15张
    func Arrange_Cards_By_Num(){
        //let person_num = Server.Person_Num()
        
    }

//MARK: - UDP
    
    ///UDP广播
    func Start_UDP_Broadcast(){
        //UDP初始化
        udp_socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        //        do{
        //            try udp_socket?.bind(toPort: 2333, interface: udp_error)
        //        }catch{
        //            if let _ = udp_error{
        //                print(udp_error!)
        //            }
        //        }
        do{
            try udp_socket?.enableBroadcast(true)
        }catch{
            print("UDP_start_error")
        }
    }
    
    ///发送UDP广播
    func Udp_Broardcast_send(){
        udp_socket?.send("HG/\(room_info?.roomID ?? "error")/\(room_info?.roomAddress ?? "error")/\(room_info?.roomCount ?? 0)".data(using: .utf8)!, toHost: udp_broadcast_address , port: 2333, withTimeout: -1, tag: 1)
        print("发送UDP")
    }
    
    ///UDP关闭
    func Close_UDP_Broadcast(){
        control_timer.invalidate()
        udp_socket?.close()
        print("UDP关闭")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("UDP发送失败")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("UDP发送成功 \(tag)")
    }

//MARK: - TCP
    
    ///TCP监听打开
    
    ///TCP监听关闭
    
    ///发送TCP Socket
}
