//
//  Networking.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/24.
//

import Foundation
import Moya
import RxSwift
import HandyJSON
import Alamofire
import Toast_Swift

public struct Networking<T: MyTargetType> {
    public let provider: MoyaProvider<T>
    
    public init(provider: MoyaProvider<T> = newDefaultProvider()) {
        self.provider = provider
    }
}

extension Networking {
    /// 请求
    public static func request(_ target: T,
                               callbackQueue: DispatchQueue? = DispatchQueue.main,
                               progress: ProgressBlock? = .none) -> Observable<Response> {
        
        return Observable.create { subscribe in
            let cancellable:Cancellable = self.init().provider.request(target, callbackQueue: callbackQueue, progress: progress) { result in
                switch result {
                case let .success(response):
                    subscribe.onNext(response)
                    subscribe.onCompleted()
                case let .failure(error):
                    
                    subscribe.onError(error)
                    subscribe.onCompleted()
                    break
                }
            }
            return Disposables.create{cancellable.cancel()}
        }
    }
}

extension Networking {
    
    public static func newDefaultProvider() -> MoyaProvider<T> {
        return newProvider(plugins: plugins)
    }
    
    static func endpointsClosure<T>() -> (T) -> Endpoint where T: MyTargetType {
        return { target in
            let defaultEndpoint = Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { target.sampleResponse },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers?.reduce(into: ApiSign.shared.getHttpHeaderFields(target: target as! MyTargetType)) { (r, e) in r[e.0] = e.1 }
            )
            return defaultEndpoint;
        }
    }
    
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                // cookies是否与请求一起发送
                request.httpShouldHandleCookies = false
                request.timeoutInterval = NetworkConfig.shared.timeoutInterval
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_ target: T) -> Moya.StubBehavior where T: MyTargetType {
        return target.stubBehavior;
    }
    
    static var plugins: [PluginType] {
        /// Loading插件
        let LoadingPlugin = NewNetworkActivityPlugin.init(networkActivityClosure: {
            (state, targetType) in
            DispatchQueue.main.async {
                guard let vc = TopVC else { return }
                switch state {
                case .began:
                    if targetType.isShowLoading {
                        vc.view.makeToastActivity(.center)
                    }
                case .ended:
                    if targetType.isShowLoading {
                        vc.view.hideToastActivity()
                    }
                }
            }
        })
        return [LoadingPlugin,networkLogger]
    }
    
    
}

func newProvider<T>(plugins: [PluginType], session: Alamofire.Session = newSession()) -> MoyaProvider<T> where T: MyTargetType {
    return MoyaProvider(endpointClosure: Networking<T>.endpointsClosure(),
                        requestClosure: Networking<T>.endpointResolver(),
                        stubClosure: Networking<T>.APIKeysBasedStubBehaviour,
                        session: session,
                        plugins: plugins)
}


func newSession(delegate: SessionDelegate = SessionDelegate(),
                serverTrustManager: ServerTrustManager? = nil) -> Alamofire.Session {
    let configuration = URLSessionConfiguration.default
    configuration.headers = .default
    
    let session = Alamofire.Session(configuration: configuration, delegate:delegate, startRequestsImmediately: true,serverTrustManager:serverTrustManager)
    return session
}


// MARK: - 扩展解析方法
public extension Observable where Element == Response {
    
    /// 转字典
    func mapDictionary() -> Observable<[String : Any]> {
        return self.flatMap { element in
            return Observable<[String : Any]> .create { observer -> Disposable in
                if let dict = try? JSONSerialization.jsonObject(with: element.data, options: .mutableContainers) as? [String: Any] {
                    observer.onNext(dict!)
                    observer.onCompleted()
                }else {
                    observer.onError(MoyaError.jsonMapping(element))
                }
                return Disposables.create()
            }
        }
    }
    /// 转业务模型
    func mapBModel<T: HandyJSON>(_ type: T.Type,showMsg:Bool = true) -> Observable<T>  {
        return self.flatMap { element in
            return Observable<T>.create { observer -> Disposable in
                if let jsonString = String(data: element.data, encoding: .utf8),
                   let model = JSONDeserializer<ResponseData<T>>.deserializeFrom(json: jsonString) {
                    // 是业务类型model，解析后返回业务data
                    if(model.code == 200) {
                        if let data = model.data {
                            observer.onNext(data)
                            observer.onCompleted()
                        }
                    }else {
                        if(showMsg) {
                            if let vc = TopVC {
                                vc.view.makeToast(model.message,position: .center)
                                print(model.message!)
                            }
                        }
                    }
                }else {
                    observer.onError(MoyaError.jsonMapping(element))
                }
                return Disposables.create()
            }
        }
    }
    /// 转模型
    func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T>  {
        return self.flatMap { element in
            return Observable<T>.create { observer -> Disposable in
                if let jsonString = String(data: element.data, encoding: .utf8),
                   let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
                    observer.onNext(model)
                    observer.onCompleted()
                }else {
                    observer.onError(MoyaError.jsonMapping(element))
                }
                return Disposables.create()
            }
        }
    }
    
}
