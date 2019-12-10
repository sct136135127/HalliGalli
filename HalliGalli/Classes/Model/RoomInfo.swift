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
    var roomID: Int?
    /// 房间是否开始
    var isstarted:Bool
    /// 当前人数
    var count: Int?
    
    init(isstarted:Bool,roomID: Int, count: Int) {
        self.isstarted = isstarted
        self.roomID = roomID
        self.count = count
    }
}
