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
    var ID: String?
    
    /// IP地址（类型可能需要更改）
    var ip_address: String?
    /// MAC地址 （类型可能需要更改）
    var mac_address: String?
    /// 子网掩码（类型可能需要更改）
    var net_mask: String?
    
    /// 牌堆
    var cards:[String]?
    
    init() {
        
    }
    
    ///获得本机基本网络信息
    func Update_User_NetInfo(){
        
    }
}
