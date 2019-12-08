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
    /// 房间是否开始
    var isstarted:Bool
    /// 当前人数
    var count: Int64?
    
    init(isstarted:Bool,roomID: Int64, count: Int64) {
        self.isstarted = isstarted
        self.roomID = roomID
        self.count = count
    }
}
