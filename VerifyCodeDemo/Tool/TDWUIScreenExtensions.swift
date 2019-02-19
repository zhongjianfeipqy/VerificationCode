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
