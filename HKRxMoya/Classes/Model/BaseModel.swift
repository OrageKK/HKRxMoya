//
//  BaseModel.swift
//  TonShow_iOS
//
//  Created by 黄坤 on 2022/10/22.
//

import Foundation
import HandyJSON


struct ResponseData<T: HandyJSON>: HandyJSON {
    var status:Int = 0
    var code: Int = 0
    var data: T?
    var message:String?
    
}


struct ResponseNullData: HandyJSON {
    var status:Int = 0
    var code: Int = 0
    var message:String?
    var data:[String:Any]?
}
