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
    var answer_flag:Bool = false
    
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
    
    /// 抢答者ID
    var answer_id:String?
    /// 抢答者识别码
    var answer_identifier:String?
    /// 抢答结果
    var answer_res:Bool?
    
    /// 游戏结束标志
    var game_end_flag:Bool?
    
    ///更新服务器网络信息
    func Update_Server_NetInfo(){
        server_info = player.userinfo
        
        //MARK:测试
//        print(userinfo.ip_address)
//        print(userinfo.identifier)
//        print(userinfo.net_mask)
        
        //添加房主信息 更新房间信息
        //playerinfo_array.append(player.userinfo)
        room_info = RoomInfo(roomID: server_info.ID ?? "error", roomAddress: server_info.ip_address ?? "error", roomCount: 1)
        //更新局域网广播地址
        Udp_broadcast_address()
        
        //打开TCP监听
        Start_TCP_Listen()
        //建立服务器与房主自己的TCP连接
        player.server_ip = server_info.ip_address
        
        if player.Start_Connect() == true {
            print("房主连接自我服务器 成功")
        }else {
            print("房主连接失败")
        }
    }
    
    ///计算UDP广播地址
    func Udp_broadcast_address(){
        //let ip = server_info.ip_address
        //let netmask = server_info.net_mask
        
        //MARK: 之后考虑是否需要处理
        //默认255.255.255.255 如果测试成功则不需要通过ip和netmask计算
        print("broadcast: \(udp_broadcast_address)")
    }

//MARK: - 基本功能

    ///返回总人数
    func Person_Num()->Int{
        return playerinfo_array.count
    }
    
    //MARK: 随机性可能有些问题 牌堆是不是要重新定一下值
    ///按照人数分发牌 一人16张 6人则每人15张
    func Arrange_Cards_By_People(){
        let person_num = Person_Num()
        let num:[Int] = Array(1...90)
        let newarray2 = num.sorted(by: {(_,_)->Bool in arc4random() < arc4random()})
        let newarray = newarray2.sorted(by: {(_,_)->Bool in arc4random() < arc4random()})
        
        if person_num == 6 {
            for i in 0..<6 {
                var temp_card:[String] = []
                for n in 0..<15 {
                    temp_card.append(Cards[newarray[i*15+n] - 1])
                }
                playerinfo_array[i].cards = temp_card
                playerinfo_array[i].card_flop = 0
                playerinfo_array[i].card_can_flop = 15
            }
        }else {
            for i in 0..<person_num {
                var temp_card:[String] = []
                for n in 0..<16 {
                    temp_card.append(Cards[newarray[i*16+n] - 1])
                }
                playerinfo_array[i].cards = temp_card
                playerinfo_array[i].card_flop = 0
                playerinfo_array[i].card_can_flop = 16
                
                print(temp_card)
            }
        }
    }
    
    ///翻牌
    func Card_Flop(userinfo:inout UserInfo)->String{
        let card_info = userinfo.cards[userinfo.card_flop!]
        let return_card_info = card_info
    
        userinfo.card_can_flop! -= 1
        userinfo.card_flop! += 1
        
        return return_card_info
    }
    
    ///撤销翻牌
    func Card_Flop_Back(userinfo:inout UserInfo)->String{
        userinfo.card_can_flop! += 1
        userinfo.card_flop! -= 1
        
        if userinfo.card_flop! == 0 {
            return "00000"
        }
        
        let card_info = userinfo.cards[userinfo.card_flop! - 1]
        let return_card_info = card_info
        return return_card_info
    }
    
    ///抢答成功或失败判断
    func Judge_Answer()->Bool{
        var count_array:[String:Int] = ["A":0,"B":0,"C":0,"D":0]
        
        for i in playerinfo_array {
            if i.card_flop != 0{
                let card_info = i.cards[i.card_flop! - 1]
                for c in card_info {
                    switch c {
                    case "1":
                        count_array["A"]! += 1
                    case "2":
                        count_array["B"]! += 1
                    case "3":
                        count_array["C"]! += 1
                    case "4":
                        count_array["D"]! += 1
                    default:
                        break
                    }
                }
            }
        }
        
        //MARK: 规则 5的倍数
        if (count_array["A"]!%5 == 0 && count_array["A"] != 0) || (count_array["B"]!%5 == 0 && count_array["B"] != 0) || (count_array["C"]!%5 == 0 && count_array["C"] != 0) || (count_array["D"]!%5 == 0 && count_array["D"] != 0) {
            return true
        }
        
        return false
    }

    /// XXX抢答成功 //是否需要洗牌？
    func Player_Answer_Right(){
        //牌分配
        var save_card:[String] = []
        //失败的玩家
        var fail_list:[Int] = []
        
        //遍历玩家，收取其他玩家翻面牌堆顶上的一张牌
        for i in 0..<playerinfo_array.count {
            if playerinfo_array[i].card_flop! != 0 && playerinfo_array[i].identifier! != answer_identifier! {
                save_card.append(playerinfo_array[i].cards[playerinfo_array[i].card_flop! - 1])
                playerinfo_array[i].card_flop! -= 1
                playerinfo_array[i].cards.remove(at: playerinfo_array[i].card_flop!)
                
                //收牌
                if playerinfo_array[i].card_flop! == 0 {
                    Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: "00000", num: "17", kind: TCPKIND.CARD_GIVE_FLOP.rawValue)
                }else {
                    Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: playerinfo_array[i].cards[playerinfo_array[i].card_flop!-1], num: "17", kind: TCPKIND.CARD_GIVE_FLOP.rawValue)
                }
                
                //判断当前遍历的玩家是否游戏结束
                if playerinfo_array[i].card_flop! == 0 && playerinfo_array[i].card_can_flop! == 0 {
                    //玩家游戏结束
                    Send_Game_Info(sock: playerinfo_array[i].tcp_socket!, kind: TCPKIND.GAME_FAIL.rawValue)
                    fail_list.append(i)
                }
            }
        }
        
        //与失败玩家断连，清理信息
        for i in 0..<fail_list.count {
            playerinfo_array[fail_list[i] - i].tcp_socket!.disconnect()
            playerinfo_array.remove(at: fail_list[i] - i)
            
            //判断游戏是否结束
            if playerinfo_array.count == 2{
                let Acount = playerinfo_array[0].card_can_flop! + playerinfo_array[0].card_flop!
                let Bcount = playerinfo_array[1].card_can_flop! + playerinfo_array[1].card_flop!
                
                //可能出现二者同牌数量的情况
                if Acount >= Bcount {
                    Send_Game_Info(sock: playerinfo_array[0].tcp_socket!, kind: TCPKIND.GAME_WIN.rawValue)
                    Send_Game_Info(sock: playerinfo_array[1].tcp_socket!, kind: TCPKIND.GAME_FAIL.rawValue)
                }else {
                    Send_Game_Info(sock: playerinfo_array[1].tcp_socket!, kind: TCPKIND.GAME_WIN.rawValue)
                    Send_Game_Info(sock: playerinfo_array[0].tcp_socket!, kind: TCPKIND.GAME_FAIL.rawValue)
                }
                
                //MARK: 游戏结束
                game_end_flag = true
                Stop_ALL_TCP()
                
                break
            }
        }
        
        //抢答成功的玩家收牌
        for i in 0..<playerinfo_array.count {
            if playerinfo_array[i].identifier! == answer_identifier! {
                if playerinfo_array[i].card_flop! == 0 {
                    playerinfo_array[i].cards.append(contentsOf: save_card)
                    playerinfo_array[i].card_can_flop! += save_card.count
                    Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: "00000", num: String(playerinfo_array[i].card_can_flop!), kind: TCPKIND.ANSWER_RIGHT.rawValue)
                }else {
                    playerinfo_array[i].card_flop! -= 1
                    let temp_card = playerinfo_array[i].cards.remove(at: playerinfo_array[i].card_flop!)
                    playerinfo_array[i].cards.append(contentsOf: save_card)
                    playerinfo_array[i].card_can_flop! += save_card.count
                    playerinfo_array[i].card_can_flop! += 1
                    playerinfo_array[i].cards.append(temp_card)
                    
                    if playerinfo_array[i].card_flop! == 0{
                        Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: "00000", num: String(playerinfo_array[i].card_can_flop!), kind: TCPKIND.ANSWER_RIGHT.rawValue)
                    }else{
                        Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: playerinfo_array[i].cards[playerinfo_array[i].card_flop!-1], num: String(playerinfo_array[i].card_can_flop!), kind: TCPKIND.ANSWER_RIGHT.rawValue)
                    }
                }
        
                break
            }
        }
        
        
    }
    
    /// XXX抢答失败
    func Player_Answer_Wrong(){
        let person_num = Person_Num() - 1
        var card_info:[String] = []
        var fail_flag = -1
        
        //抢答失败玩家分发牌
        for i in 0..<playerinfo_array.count {
            if playerinfo_array[i].identifier! == answer_identifier! {
                //判断该玩家是否失败
                //未翻面牌不够分发给其他人
                if playerinfo_array[i].card_can_flop! < person_num {
                    fail_flag = i
                    break
                }
                
                //剩余牌可以分发
                for _ in 0..<person_num {
                    card_info.append(playerinfo_array[i].cards.removeLast())
                }
                playerinfo_array[i].card_can_flop! -= person_num
                
                Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: "00000", num: String(playerinfo_array[i].card_can_flop!), kind: TCPKIND.ANSWER_WRONG.rawValue)
            }
        }
        
        //玩家游戏失败，TCP断连，清理信息
        if fail_flag != -1 {
            Send_Game_Info(sock: playerinfo_array[fail_flag].tcp_socket!, kind: TCPKIND.GAME_FAIL.rawValue)
            playerinfo_array[fail_flag].tcp_socket!.disconnect()
            playerinfo_array.remove(at: fail_flag)
            
            //判断获胜
            if playerinfo_array.count == 2{
                let Acount = playerinfo_array[0].card_can_flop! + playerinfo_array[0].card_flop!
                let Bcount = playerinfo_array[1].card_can_flop! + playerinfo_array[1].card_flop!
                
                //可能出现二者同牌数量的情况
                if Acount >= Bcount {
                    Send_Game_Info(sock: playerinfo_array[0].tcp_socket!, kind: TCPKIND.GAME_WIN.rawValue)
                    Send_Game_Info(sock: playerinfo_array[1].tcp_socket!, kind: TCPKIND.GAME_FAIL.rawValue)
                }else {
                    Send_Game_Info(sock: playerinfo_array[1].tcp_socket!, kind: TCPKIND.GAME_WIN.rawValue)
                    Send_Game_Info(sock: playerinfo_array[0].tcp_socket!, kind: TCPKIND.GAME_FAIL.rawValue)
                }
                
                //MARK: 游戏结束
                game_end_flag = true
                Stop_ALL_TCP()
            }
            return
        }
        
        //分发给其他玩家牌
        for i in 0..<playerinfo_array.count {
            if playerinfo_array[i].identifier! != answer_identifier! {
                playerinfo_array[i].cards.append(card_info.removeLast())
                playerinfo_array[i].card_can_flop! += 1
                
                Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: "00000", num: String(playerinfo_array[i].card_can_flop!), kind: TCPKIND.CARD_RECEIVE.rawValue)
            }
        }
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
        room_info?.roomCount = Person_Num()
        
        udp_socket?.send("HG/\(room_info?.roomID ?? "error")/\(room_info?.roomAddress ?? "error")/\(room_info?.roomCount ?? 0)".data(using: .utf8)!, toHost: udp_broadcast_address , port: 2333, withTimeout: -1, tag: 1)
        //print("发送UDP")
    }
    
    ///UDP关闭
    func Close_UDP_Broadcast(){
        udp_socket?.close()
        print("UDP关闭")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("UDP发送失败")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        //print("UDP发送成功 \(tag)")
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
    
    //MARK: 待测试 可能会由于房主回到主界面而崩溃！
    ///房主离开时断开所有连接 游戏结束时断开所有连接
    func Stop_ALL_TCP(){
        for i in playerinfo_array {
            i.tcp_socket?.disconnect()
        }
        playerinfo_array.removeAll()
        
        tcp_socket?.delegate = nil
        tcp_socket = nil
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
        newplayer.tcp_socket = newSocket
        newplayer.ip_address = newSocket.connectedHost
        playerinfo_array.append(newplayer)
        
        //发送更新房间列表人数的包
        Send_Room_Num()
        
        //继续监听该客户端的TCP请求
        newSocket.readData(withTimeout: -1, tag: 0)
        print("与\(newSocket.connectedHost!) 建立连接")
        
        //房主加入
        if Person_Num() == 1 {
            //更新房主在玩家列表的信息
            playerinfo_array[0].ID = player.userinfo.ID
            playerinfo_array[0].identifier = player.userinfo.identifier
            playerinfo_array[0].ip_address = player.userinfo.ip_address
        }
    }
    
    ///接收已加入player的TCP请求内容
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let content:String = String(data:data,encoding: .utf8) ?? "wrong"
        if content.split(separator: "&")[0] == "HG" {
            if content.split(separator: "&")[1] == TCPKIND.ADD_PLAYER.rawValue {
                //更新player信息
                let info = String(content.split(separator: "&")[2])
                
                let id = info.split(separator: "/")[0]
                let ip = info.split(separator: "/")[1]
                let identifier = info.split(separator: "/")[2]
                
                for i in 0..<playerinfo_array.count {
                    if let _ = playerinfo_array[i].ip_address{
                        if playerinfo_array[i].ip_address! == String(ip) {
                            playerinfo_array[i].ID = String(id)
                            playerinfo_array[i].identifier = String(identifier)
                            
                            break
                        }
                    }
                }
            }else if content.split(separator: "&")[1] == TCPKIND.PLAYER_LEAVE.rawValue  {
                //清理断连玩家信息
                let identifier = String(content.split(separator: "&")[2].split(separator: "/")[2])
                
                for i in 0..<playerinfo_array.count {
                    if let temp = playerinfo_array[i].identifier {
                        if temp == identifier {
                            playerinfo_array.remove(at: i)
                            break
                        }
                    }
                }
                
                Send_Room_Num()
            }else if content.split(separator: "&")[1] == TCPKIND.CARD_FLOP.rawValue{
                //翻牌
                let identifier = String(content.split(separator: "&")[2].split(separator: "/")[2])
                
                for i in 0..<playerinfo_array.count {
                    if let info = playerinfo_array[i].identifier {
                        if info == identifier {
                            if let _ = playerinfo_array[i].card_can_flop{
                                if playerinfo_array[i].card_can_flop != 0 {
                                    //有牌可以翻
                                    let card_info = Card_Flop(userinfo: &playerinfo_array[i])
                                    Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: card_info, num: String(playerinfo_array[i].card_can_flop!),kind:TCPKIND.CARD_FLOP.rawValue)
                                }
                            }
                        }
                    }
                }
            }else if content.split(separator: "&")[1] == TCPKIND.CARD_FLOP_BACK.rawValue{
                //撤销翻牌
                let identifier = String(content.split(separator: "&")[2].split(separator: "/")[2])
                
                for i in 0..<playerinfo_array.count {
                    if let info = playerinfo_array[i].identifier {
                        if info == identifier {
                            if let _ = playerinfo_array[i].card_flop{
                                if playerinfo_array[i].card_flop != 0 {
                                    //有牌可以翻
                                    let card_info = Card_Flop_Back(userinfo: &playerinfo_array[i])
                                    Send_Card_Info(sock: playerinfo_array[i].tcp_socket!, card_info: card_info, num: String(playerinfo_array[i].card_can_flop!),kind:TCPKIND.CARD_FLOP_BACK.rawValue)
                                }
                            }
                        }
                    }
                }
            }else if content.split(separator: "&")[1] == TCPKIND.CALLING_RING.rawValue{
                //接收到抢答信息
                
                //第一个抢答者
                if answer_flag == false {
                    //防止其他人继续抢答 flag将在弹窗结束后置回false
                    answer_flag = true
                    let identifier = String(content.split(separator: "&")[2].split(separator: "/")[2])
                    
                    for i in 0..<playerinfo_array.count {
                        if let info = playerinfo_array[i].identifier {
                            if info == identifier {
                                answer_res = Judge_Answer()
                                answer_id = playerinfo_array[i].ID!
                                answer_identifier = playerinfo_array[i].identifier!
                                
                                //controller show msg
                                show_answer_flag = true
                            }
                        }
                    }
                }
                
            }
        }
        
        //继续监听
        sock.readData(withTimeout: -1, tag: 0)
        
    }
    
    ///玩家与服务器断连 包括主动断连和被动断连
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
    }
    
//MARK: - TCP INFO
    ///发送房间人数
    func Send_Room_Num(){
        let content:Data = Tcp_Socket_ChangeInto_Data(tcp_socket: TCP_SOCKET(TCP_KIND: TCPKIND.Update_RoomPlayer_Num.rawValue, INFO: String(Person_Num())))
        
        for i in playerinfo_array {
            Send_TCP_Socket(sock: i.tcp_socket!, socket_data: content)
        }
    }
    
    ///发送游戏开始信息
    func Send_Game_Start(){
        let content:Data = Tcp_Socket_ChangeInto_Data(tcp_socket: TCP_SOCKET(TCP_KIND: TCPKIND.GAME_START.rawValue, INFO: String(1)))
        
        for i in playerinfo_array {
            Send_TCP_Socket(sock: i.tcp_socket!, socket_data: content)
        }
    }
    
    ///发送房间关闭信息
    func Send_Room_Close(){
        let content:Data = Tcp_Socket_ChangeInto_Data(tcp_socket: TCP_SOCKET(TCP_KIND: TCPKIND.ROOM_CLOSE.rawValue, INFO: String(-1)))
        
        for i in playerinfo_array {
            Send_TCP_Socket(sock: i.tcp_socket!, socket_data: content)
        }
    }
    
    ///发送牌信息 翻面展示的牌/未翻面牌的数量 Kind：信息种类
    func Send_Card_Info(sock: GCDAsyncSocket,card_info: String,num: String,kind:String){
        let content:Data = Tcp_Socket_ChangeInto_Data(tcp_socket: TCP_SOCKET(TCP_KIND: kind, INFO: card_info + "/" + num))
        
        Send_TCP_Socket(sock: sock, socket_data: content)
    }
    
    ///发送游戏结果信息
    func Send_Game_Info(sock: GCDAsyncSocket,kind:String){
        let content:Data = Tcp_Socket_ChangeInto_Data(tcp_socket: TCP_SOCKET(TCP_KIND: kind, INFO: "00000" + "/" + "0"))
        
        Send_TCP_Socket(sock: sock, socket_data: content)
    }
}
