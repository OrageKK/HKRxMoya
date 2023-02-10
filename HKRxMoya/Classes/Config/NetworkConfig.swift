//
//  NetworkConfig.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/24.
//

import Foundation
import Alamofire
import Moya

public class NetworkConfig: NSObject {
    
    public var baseURL: String = "https://query.asilu.com/"
    public var headers: [String: String]? = defaultHeaders()
    public var parameters: [String: Any]? = defaultParameters()
    public var timeoutInterval: Double = 20.0
    
    public static let shared = NetworkConfig()
    private override init() {}
    
    public static func defaultHeaders() -> [String : String]? {
        return [
            "platform" : "iOS",
                "version" : "1.0",
                "Content-type": "application/json"
        ]
    }
    
    public static func defaultParameters() -> [String : Any]? {
        return [:]
    }
    
}
