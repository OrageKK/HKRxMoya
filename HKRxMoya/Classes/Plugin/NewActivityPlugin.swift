//
//  NewActivityPlugin.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/24.
//

import Foundation
import Moya


/// Notify a request's network activity changes (request begins or ends).
public final class NewNetworkActivityPlugin: PluginType {
    
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType, _ target: MyTargetType) -> Void
    let networkActivityClosure: NetworkActivityClosure
    
    /// Initializes a NetworkActivityPlugin.
    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }
    
    // MARK: Plugin
    
    /// Called by the provider as soon as the request is about to start
    public func willSend(_ request: RequestType, target: TargetType) {
        networkActivityClosure(.began, target as! MyTargetType)
    }
    
    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        networkActivityClosure(.ended, target as! MyTargetType)
    }
}
