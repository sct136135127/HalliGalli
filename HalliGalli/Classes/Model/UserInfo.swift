//
//  User.swift
//  HalliGalli
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import UIKit

class UserInfo: Codable {
    /// 用户id
    var Username: String?
    
    /// 用户身份，0为玩家（默认），1为房主
    var status: Int
    
    init(Username: String, status: Int) {
        self.Username = Username
        self.status = status
    }
}
