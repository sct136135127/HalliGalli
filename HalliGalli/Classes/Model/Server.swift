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
class Server: NSObject, GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate {
    
    ///房间信息
    var room_info:RoomInfo?
    
    ///牌堆变化标志--用于服务器回复信息，抢答优先级
    var card_change_flag:Bool = false
    
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
    
    ///TCP socket
    var tcp_socket:GCDAsyncSocket?
    
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
        
        //MARK: 之后考虑是否需要处理
        //默认255.255.255.255 如果测试成功则不需要通过ip和netmask计算
        print("broadcast: \(udp_broadcast_address)")
    }

//MARK: - 基本信息

    ///返回总人数
    func Person_Num()->Int{
        return self.playerinfo_array.count
    }
    
    //MARK: 戴 待完善
    ///按照人数分发牌 一人16张 6人则每人15张
    func Arrange_Cards_By_People(){
        //let person_num = Server.Person_Num()
        
    }

//MARK: - UDP
    
    ///UDP广播
    func Start_UDP_Broadcast(){
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
    func Start_TCP_Listen(){
        tcp_socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)

        do {
            try tcp_socket?.accept(onPort: 3332)
            print("打开监听成功")
        }catch _ {
            print("打开监听失败")
        }
    }
    
    ///TCP监听关闭
    func Stop_TCP_Listen(){
        
    }
    
    ///发送TCP Socket
    func Send_TCP_Socket(){
        
//        // socket是保存的客户端socket, 表示给这个客户端socket发送消息
//        - (IBAction)sendMessage:(id)sender
//        {
//            if(self.clientSockets == nil) return;
//            NSData *data = [self.messageTextF.text dataUsingEncoding:NSUTF8StringEncoding];
//            // withTimeout -1 : 无穷大,一直等
//            // tag : 消息标记
//            [self.clientSockets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj writeData:data withTimeout:-1 tag:0];
//            }];
//        }
        
    }
    
    //接收TCP Socket
    ///接收新用户的加入TCP
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        //加入该用户信息
        
        
        //继续监听改客户端的TCP请求
        newSocket.readData(withTimeout: -1, tag: 0)
    }
    
    ///接收TCP
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        <#code#>
        
        sock.readData(withTimeout: -1, tag: 0)
    }
}
