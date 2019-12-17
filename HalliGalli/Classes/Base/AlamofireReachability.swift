//
//  AlamofireReachability.swift
//  HalliGalli
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import Alamofire

enum ReachabilityStatus{
    case notReachable
    case unknown
    case ethernetOrWiFi
    case wwan
}

class AlamofireReachability:NSObject{
    static let reachability = AlamofireReachability()
    func networkReachability(_ manager:NetworkReachabilityManager,reachabilityStatus:@escaping (ReachabilityStatus)->Void){
        manager.listener={ status in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
                reachabilityStatus(.notReachable)
                print("当前无网络")
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown{
                reachabilityStatus(.unknown)
                print("未知网络")
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi){
                reachabilityStatus(.ethernetOrWiFi)
                print("当前使用wifi")
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.wwan){
                reachabilityStatus(.wwan)
                print("当前使用蜂窝网络")
            }
        }
        manager.startListening()
    }
}
