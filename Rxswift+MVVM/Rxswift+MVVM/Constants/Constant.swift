//
//  Constant.swift
//  UBanHuiXueTech
//
//  Created by 潘强 on 2019/3/12.
//  Copyright © 2019 USI Technology (Shenzhen) Company. All rights reserved.
//

import UIKit

let OK_CODE = 200

// 版本号key
let K_VERSION_STRING                  = "CFBundleShortVersionString"
//友盟 APPkey
let UM_APP_KEY                        =  ""

// 版本号
let WXY_VERSION = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

// 屏幕宽
let Screen_Width = UIScreen.main.bounds.size.width

// 屏幕高
let Screen_Height = UIScreen.main.bounds.size.height

// 状态栏高
let StatusBarHeight: CGFloat   = UIApplication.shared.statusBarFrame.size.height

// iphone X
let IsiPhoneX = (Screen_Height == 812 || Screen_Height == 896) ? true : false

// 导航栏高
let NavigationBarHeight : CGFloat = IsiPhoneX ? 88 : 64

// tabbar高度
let TabBarHeight : CGFloat = IsiPhoneX ? 49 + 34 : 49

// iPhoneX竖屏底部指示部分
let DEVICE_INDICATOR_HEIGHT: CGFloat  = IsiPhoneX ? 34 : 0

// iPhoneX横屏底部指示部分
let LAND_INDICATOR_HEIGHT: CGFloat = IsiPhoneX ? 21 : 0

// iPhoneX横屏左右安全区域宽度
let LAND_SAFEAREA_WIDTH: CGFloat   = IsiPhoneX ? 44 : 0

// 常用间距
let Margin = 16

// 按屏幕宽度比例缩放(dp)
func realValue(_ value:Float) -> CGFloat {
    return CGFloat(value) * UIScreen.main.bounds.size.width / 375
}

// 缩放字体
func SYS_FONT(_ value:Float) -> UIFont {
    return UIFont.systemFont(ofSize: realValue(value))
}

// 缩放粗体
func BOLD_FONT(_ value:Float) -> UIFont {
    return UIFont.boldSystemFont(ofSize: realValue(value))
}

/***  正则表达式  ***/
// 手机号码
let phoneRegular = "^((13[0-9])|(18[0-9])|(14[5,7])|(15[^4,\\D])|(17[^2,^4,^9,\\D]))\\d{8}$"


// 常用色值

let MAXVALUE = 0x3f3f3f3f
