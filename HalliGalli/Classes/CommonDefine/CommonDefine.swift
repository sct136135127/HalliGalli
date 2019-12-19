//
//  CommonDefine.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import UIKit


/// 房间列表数据源
var dataSource: [RoomInfo] = []

/// 服务器
var server:Server = Server()
/// 玩家
var player:Player = Player()

///横屏是否显示状态栏，使用私有API显示， 崩溃请设置为false
let kShowStatusBarWhenLandScape: Bool = true
/// 项目主要颜色
let kMainThemeColor: UIColor = UIColor(hex: 0x0084FB)

/// 所有牌的种类  90张 3-5人一人16张 6人一人15张
let Cards:[String] = ["00100","00100","00100","01010","01010","01010","01110","01110","01110","11011","11011","11011","11111","11111","00200","00200","00200","02020","02020","02020","02220","02220","02220","22022","22022","22022","22222","22222","00300","00300","00300","03030","03030","03030","03330","03330","03330","33033","33033","33033","33333","33333","00400","00400","00400","04040","04040","04040","04440","04440","04440","44044","44044","44044","44444","44444","04120","04340","04240","04140","34044","24044","14044","03020","02040","03230","03430","03130","23033","43033","13033","11211","13042","01210","01410","01310","21011","41011","31011","03010","03040","12022","42022","32022","02120","02420","02320","03120","02010","04010"]

//MARK: 待完善
///TCP socket信息种类
enum TCPKIND:String{
    case ADD_PLAYER //加入玩家 (连接成功后发送加入的玩家信息)
    case Update_RoomPlayer_Num //更新等待房间人数信息
    case GAME_START //游戏开始
    
    case ROOM_CLOSE //房间解散
    case PLAYER_LEAVE //玩家离开
    
    case CARD_FLOP // 翻牌
    case CARD_FLOP_BACK // 误触，翻回之前的牌
    
    case CARD_GIVE_FLOP // 翻面牌减少一张
    case CARD_RECEIVE // 接收到他人的发牌
    
    case CALLING_RING // 抢答
    case ANSWER_RIGHT // 抢答成功
    case ANSWER_WRONG // 抢答失败
    
    case GAME_FAIL // 游戏失败
    case GAME_WIN // 游戏胜利
}

// socket格式: HG$@TCP_KIND$@Info
///TCP socket定义
struct TCP_SOCKET{
    let GAMEFLAG = "HG"
    var TCP_KIND:String?
    var INFO:String?
}

///TCP_SOCKET信息转换成DATA
func Tcp_Socket_ChangeInto_Data(tcp_socket: TCP_SOCKET)->Data{
    let content = tcp_socket.GAMEFLAG + "&" + tcp_socket.TCP_KIND! + "&" + tcp_socket.INFO!
    
    return content.data(using: .utf8)!
}


