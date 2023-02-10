//
//  NetworkStatusManager.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/24.
//

import Foundation
import Alamofire
import CoreTelephony

public enum NetworkStatus {
    /// 未知网络
    case unknown
    /// 无网络
    case notReachable
    /// WiFi
    case reachableViaWiFi
    /// 蜂窝数据
    case reachableViaWWAN
}

public class NetworkStatusManager: NSObject {
    
    public static let shared = NetworkStatusManager()
    private override init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    var isReachable: Bool { return isReachableOnWWAN || isReachableOnWiFi }
    
    var isReachableOnWWAN: Bool { return networkStatus == .reachableViaWWAN }
    
    var isReachableOnWiFi: Bool { return networkStatus == .reachableViaWiFi }
    
    var networkStatus: NetworkStatus {
        guard let status = reachabilityManager?.status else {
            return .unknown
        }
        switch status {
        case .unknown:
            return NetworkStatus.unknown
        case .notReachable:
            return NetworkStatus.notReachable
        case .reachable(.ethernetOrWiFi):
            return NetworkStatus.reachableViaWiFi
        case .reachable(.cellular):
            return NetworkStatus.reachableViaWWAN
        }
    }
    
    
    
    /// 开启网络监听
    public func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                print("📶 当前设备网络类型： 无网络")
                
            case .unknown :
                print("📶 当前设备网络类型： 未知网络")
                
            case .reachable(.ethernetOrWiFi):
                print("📶 当前设备网络类型： WiFI")
                
            case .reachable(.cellular):
                print("📶 当前设备网络类型： 蜂窝网络")
            }
        })
    }
    
    ///判断网络是否有权限
    public func isNetworkPermissions(action :@escaping (_ state:Bool) -> Void){
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            if state == .notRestricted || state == .restrictedStateUnknown{
                action(true)
            } else {
                action(false)
            }
        }
        let state = cellularData.restrictedState
        if state == .notRestricted || state == .restrictedStateUnknown{
            action(true)
        } else {
            action(false)
        }
    }
}

