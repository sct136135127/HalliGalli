//
//  RoomInfo.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class RoomInfo{
    
    /// 房间ID
    var roomID: String?
    /// 房间ip
    var roomAddress:String?
    /// 当前人数
    var roomCount: Int?
    /// 接收时间
    var rev_time: Date?
    
    init(roomID:String,roomAddress: String, roomCount: Int) {
        self.roomID = roomID
        self.roomAddress = roomAddress
        self.roomCount = roomCount
    }
}
