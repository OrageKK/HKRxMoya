//
//  TestAPI.swift
//  HKRxMoya_Example
//
//  Created by 黄坤 on 2023/2/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Moya
import HKRxMoya

enum TestAPI {
    case weather(address:String)
}

extension TestAPI:MyTargetType {
    
    var path: String {
        switch self {
        case .weather(address: _):
            return "weather/gaode"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .weather(address: let address):
            return .requestParameters(parameters: ["address":address,"now":"1"], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    // 是否添加loading
    public var isShowLoading: Bool {
        return true
    }
    
}
