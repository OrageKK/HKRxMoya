//
//  MoyaPlugin.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/21.
//

import Foundation
import Moya
import Toast_Swift
import Alamofire

// MARK: 网络日志
/// 日志插件
public final class NetworkLogger: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        let log = self.generateRequestLog(request, target: target)
        print(log)
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        let log = self.generateResponseLog(result, target: target)
        print(log)
    }
    
    func generateRequestLog(_ request: RequestType, target: TargetType) -> String {
        let headers = target.headers?.reduce(into: ApiSign.shared.getHttpHeaderFields(target: target as! MyTargetType)) { (r, e) in r[e.0] = e.1 }
        var log = "\n"
        log += "===============💜💜💜 Request 💜💜💜 ===============\n"
        let url = "\(target.baseURL.absoluteString)\(target.path)"
        log += "URL: \(url)\n"
        log += "Host: \(target.baseURL.absoluteString)\n"
        log += "Path: \(target.path)\n"
        log += "Method: \(target.method.rawValue)\n"
        log += "Header: \(headers ?? [:])\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        log += "Time: \(formatter.string(from: Date()))\n"
        log += "Task: \(target.task)\n"
        log += "===============💜💜💜 End 💜💜💜===============\n"
        return log
    }
    
    func generateResponseLog(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> String {
        var log = "\n"
        do {
            let response = try result.get()
            log += "===============💚💚💚 Response 💚💚💚===============\n"
            let url = "\(target.baseURL.absoluteString)\(target.path)"
            log += "URL: \(url)\n"
            if let requestConfig = target as? MyTargetType {
                let usedTime = Date().timeIntervalSince1970 - requestConfig.startTime.timeIntervalSince1970
                let usedTimeStr = String(format: "%.1f", usedTime)
                log += "UsedTime: \(usedTimeStr) s\n"
            }
            let data = String(data: response.data, encoding: .utf8)
            log += data != nil ? "Data: \(data!) \n" : "Data: \n"
            log += "===============💚💚💚 End 💚💚💚===============\n"
        }catch {
            if let error = error as? MoyaError {
                log += "===============👿👿👿 Response 👿👿👿===============\n"
                let url = "\(target.baseURL.absoluteString)\(target.path)"
                log += "URL: \(url)\n"
                log += "Error: \(error.errorDescription ?? "") \n"
                log += "Code: \(error.errorCode) \n"
                if let requestConfig = target as? MyTargetType {
                    let usedTime = Date().timeIntervalSince1970 - requestConfig.startTime.timeIntervalSince1970
                    let usedTimeStr = String(format: "%.1f", usedTime)
                    log += "UsedTime: \(usedTimeStr) s\n"
                }
                log += "=============== End ===============\n"
            }
        }
        return log
    }
    
}
/// 日志插件
let networkLogger = NetworkLogger()
