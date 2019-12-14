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
    
    //MARK: 待测试
    ///房主离开时断开所有连接 游戏结束时断开所有连接
    func Stop_ALL_TCP(){
        for i in playerinfo_array {
            i.tcp_socket?.disconnect()
        }
        playerinfo_array.removeAll()
    }
    
    ///发送TCP Socket
    func Send_TCP_Socket(sock: GCDAsyncSocket,socket_data: Data){
        sock.write(socket_data, withTimeout: -1, tag: 0)
    }
    
    //MARK: 待测试
    //接收TCP Socket
    ///接收新player的加入TCP
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        //加入该用户信息
        var newplayer = UserInfo()
        newplayer.tcp_socket = sock
        newplayer.ip_address = sock.connectedHost
        playerinfo_array.append(newplayer)
        
        //继续监听该客户端的TCP请求
        newSocket.readData(withTimeout: -1, tag: 0)
        print("与\(sock.connectedHost!) 建立连接")
    }
    
    //MARK: 待完善
    ///接收已加入player的TCP请求内容
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        <#code#>
        
        //继续监听
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    //MARK: 待测试
    ///玩家与服务器断连 包括主动断连和被动断连
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        //清理断连玩家信息
        let address = sock.connectedHost
        
        for i in 0..<playerinfo_array.count {
            if let temp = playerinfo_array[i].ip_address {
                if temp == address! {
                    playerinfo_array.remove(at: i)
                    break
                    
                    //之后需要更新总人数
                }
            }
        }
        
        print("与\(sock.connectedHost!)断连")
    }
    
}
