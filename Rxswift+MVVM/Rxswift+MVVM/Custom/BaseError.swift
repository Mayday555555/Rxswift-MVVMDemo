//
//  BaseError.swift
//  Rxswift+MVVM
//
//  Created by xuanze on 2020/1/19.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit

class BaseError: Error {
    var desc: String = ""
    var localizedDescription: String {
        return desc
    }
    init(desc: String) {
        self.desc = desc
    }
}
