//
//  RoomInfo.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import UIKit

class RoomInfo: Codable {
    /// 房间ID
    var roomID: Int64?
    
    /// 当前人数
    var count: Int64?
    
    init(roomID: Int64, count: Int64) {
        self.roomID = roomID
        self.count = count
    }
}
