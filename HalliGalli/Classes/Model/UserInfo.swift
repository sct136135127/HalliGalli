//
//  User.swift
//  HalliGalli
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 HalliGalli. All rights reserved.
//

import Foundation
import UIKit
import CocoaAsyncSocket

struct UserInfo {
    /// 用户id
    var ID: String?
    
    /// IP地址（类型可能需要更改）
    var ip_address: String?
    /// 识别码
    var identifier: String?
    /// 子网掩码（类型可能需要更改），可能不需要
    var net_mask: String?
    
    /// 牌堆
    var cards:[String] = []
    
    ///TCP Socket存储
    var tcp_socket:GCDAsyncSocket?
   

//MARK: - 获取信息

    //待理解
    ///获取本机ip和子网掩码
    mutating func GetIPNetmask()
    {
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr;
            
            while ptr != nil {
                let name = String.init(utf8String: ptr!.pointee.ifa_name)   //[NSString stringWithUTF8String:ptr->ifa_name];
                
                if (name == "en0")
                {
                    let flags = Int32((ptr?.pointee.ifa_flags)!)
                    var addr = ptr?.pointee.ifa_addr.pointee
                    
                    // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                        if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                            // Convert interface address to a human readable string:
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            
                            if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.init(validatingUTF8:hostname) {
                                    
                                    var net = ptr?.pointee.ifa_netmask.pointee
                                    var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                    
                                    getnameinfo(&net!, socklen_t((net?.sa_len)!), &netmaskName, socklen_t(netmaskName.count),
                                                nil, socklen_t(0), NI_NUMERICHOST)// == 0
                                    
                                    if let netmask = String.init(validatingUTF8:netmaskName) {
                                        print("address= \(address),netmask\(netmask)")
                                        ip_address = address
                                        net_mask = netmask
                                    }
                                }
                            }
                        }
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
    }
    
    ///获取本机UUID（唯一标志码）
    mutating func GetIdentifier(){
        identifier = UIDevice.current.identifierForVendor?.uuidString
    }
}
