//
//  MyTargetType.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/24.
//

import Foundation
import Moya

public typealias HTTPMethod = Moya.Method
public typealias MyValidationType = Moya.ValidationType
public typealias MySampleResponse = Moya.EndpointSampleResponse
public typealias MyStubBehavior = Moya.StubBehavior

public protocol MyTargetType: TargetType {
    var isShowLoading: Bool { get }
    var parameters: [String: Any]? { get }
    var stubBehavior: MyStubBehavior { get }
    var sampleResponse: MySampleResponse { get }
}

extension MyTargetType {
    
    /// 基础URL
    public var baseURL: URL { return URL(string: NetworkConfig.shared.baseURL)! }
    /// 基础请求头
    public var headers: [String : String]? { return NetworkConfig.shared.headers }
    /// 基础参数
    public var parameters: [String: Any]? { return NetworkConfig.shared.parameters }
    /// 是否显示loading
    public var isShowLoading: Bool { return false }
    /// 超时时长
    public var timeoutInterval: TimeInterval{return NetworkConfig.shared.timeoutInterval}
    /// 开始时间，用于请求耗时计算
    public var startTime: Date {return Date()}
    /// 请求类型，Data/Downlaod/Upload
    public var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    /// 请求方式
    public var method: HTTPMethod {
        return .post
    }
    
    /// callbackQueue
    public var callbackQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    public var validationType: MyValidationType {
        return .successCodes
    }
    /// 模拟数据开关 .never immediate(立刻返回) delayed(延时返回)
    public var stubBehavior: StubBehavior {
        return .never
    }
    
    /// 模拟数据
    public var sampleData: Data {
        return "response: test data".data(using: String.Encoding.utf8)!
    }
    /// 模拟响应
    public var sampleResponse: MySampleResponse {
        return .networkResponse(200, self.sampleData)
    }
}

func myBaseUrl(_ path: String) -> String {
    if path.isCompleteUrl { return path }
    return NetworkConfig.shared.baseURL;
}

func myPath(_ path: String) -> String {
    if path.isCompleteUrl { return "" }
    return path;
}

extension String {
    var isCompleteUrl: Bool {
        let scheme = self.lowercased()
        if scheme.contains("http") { return true }
        return false
    }
}
