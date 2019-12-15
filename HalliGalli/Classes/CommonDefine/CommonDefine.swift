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

/// 所有牌的种类，前缀为0  90张 3-5人一人16张 6人一人15张
let Cards:[String] = ["000100","000100","000100","001010","001010","001010","001110","001110","001110","011011","011011","011011","011111","011111","000200","000200","000200","002020","002020","002020","002220","002220","002220","022022","022022","022022","022222","022222","000300","000300","000300","003030","003030","003030","003330","003330","003330","033033","033033","033033","033333","033333","000400","000400","000400","004040","004040","004040","004440","004440","004440","044044","044044","044044","044444","044444","004120","004340","004240","004140","034044","024044","014044","003020","002040","003230","003430","003130","023033","043033","013033","011211","013042","001210","001410","001310","021011","041011","031011","003010","003040","012022","042022","032022","002120","002420","002320","003120","002010","004010"]

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


