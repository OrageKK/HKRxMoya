//
//  TestModel.swift
//  HKRxMoya_Example
//
//  Created by 黄坤 on 2023/2/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

// MARK: - Weather
struct Weather:HandyJSON {
    var status, count, info, infocode: String?
    var lives: [Life]?
}

// MARK: - Life
struct Life:HandyJSON {
    var province, city, adcode, weather: String?
    var temperature, winddirection, windpower, humidity: String?
    var reporttime, temperatureFloat, humidityFloat: String?
}
