//
//  Define.swift
//  HKRxMoya_Example
//
//  Created by 黄坤 on 2023/2/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

var TopVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}
