//
//  CustomLog.swift
//  UBanHuiXueTech
//
//  Created by 陈铉泽 on 2019/3/13.
//  Copyright © 2019 USI Technology (Shenzhen) Company. All rights reserved.
//

import UIKit

class CustomLog: NSObject {
    class func e(_ msg: Any, fileName: String = #file, lineNum: Int = #line) {
        if LOG_ENABLED {
            print("[\((fileName as NSString).lastPathComponent)(\(lineNum))]\(msg)")
        }
    }
}
