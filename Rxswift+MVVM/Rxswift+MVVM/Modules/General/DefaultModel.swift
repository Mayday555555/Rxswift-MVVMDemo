//
//  User.swift
//  UBanHuiXueTech
//
//  Created by 潘强 on 2019/3/12.
//  Copyright © 2019 USI Technology (Shenzhen) Company. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 基础的model类
class DefaultModel {
    
    var json = JSON()
    
    required init(json: JSON) {
        self.json = json
    }
    
    func jsonStrValue(key:String) -> String {
        return json[key].stringValue
    }
    
    func jsonIntValue(key:String) -> Int {
        return json[key].intValue
    }
    
    func jsonFloatValue(key:String) -> Float {
        return json[key].floatValue
    }
    
    func jsonBoolValue(key:String) -> Bool {
        return json[key].boolValue
    }

    func jsonArrayMapValue<C:DefaultModel>(key:String) -> [C] {
       return json[key].arrayValue.map{C(json: $0)}
    }
    
    func jsonArrayObjectValue<C>(key:String) -> [C] {
        return json[key].arrayObject as! [C]
    }
    
    func transToJsonDict() -> [String: Any] {
        let m = Mirror(reflecting: self)
        var dict = [String: Any]()
        for (key,value) in m.children {
            if let keystr = key {
                if let arr = value as? Array<Any> {
                    var arrDict = [[String: Any]]()
                    for valueIn in arr {
                        if let model = valueIn as? DefaultModel {
                            let modelDict = model.transToJsonDict()
                            arrDict.append(modelDict)
                        }
                    }
                    dict.updateValue(arrDict, forKey: keystr)
                } else {
                    dict.updateValue(value, forKey: keystr)
                }
            }
            
        }
        return dict
    }
    
}
