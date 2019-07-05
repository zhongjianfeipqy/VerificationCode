//
//  TDWUIScreenExtensions.swift
//  TDWCashLoan
//
//  Created by ZhengRuSong on 2017/8/4.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    static func tdw_width() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    static func tdw_height() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    static func tdw_size() -> CGSize {
        return UIScreen.main.bounds.size
    }
}

public extension UIColor {
    
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(TDWValueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((TDWValueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((TDWValueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(TDWValueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(TDWValueRGB: UInt) {
        self.init(
            red: CGFloat((TDWValueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((TDWValueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(TDWValueRGB & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
}
