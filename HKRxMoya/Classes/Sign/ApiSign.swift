//
//  TSAPISign.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/11/11.
//

import Foundation
import RxSwift
import HandyJSON
/// 可用来做鉴权和接口加密处理
class ApiSign {
    /// 私钥
    private let privatekey = "hRJvqjFYaju7NEFpWwik6hQxZgo52Cu5"
    private lazy var disposeBag:DisposeBag = DisposeBag()
    
    static let shared = ApiSign()
    // 添加鉴权header
    func getHttpHeaderFields(target:MyTargetType) -> [String: String] {
        
        // 获取请求参数
        var parameter:[String:Any]?
        switch target.task {
        case let .requestParameters(parameters, _):
            parameter = parameters
        default : break
        }
        
        let businessHeader:[String:String] = [
            :
        ]
        
        
        return businessHeader
    }
    
}

