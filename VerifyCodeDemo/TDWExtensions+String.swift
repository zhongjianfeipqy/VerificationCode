//
//  TDWExtensions+String.swift
//  TuanDaiV4
//
//  Created by John on 2017/10/19.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation

extension String {
    
    /// 判断当前的内容是否满足数值要求
    ///
    /// - Parameters:
    ///   - integerCount: 限制的整数位数，nil则不限制，0则无法输入整数和小数
    ///   - decimalCount: 限制的小数点位数，nil则不限制，0则无法输入小数和小数点
    /// - Returns: 是否满足条件
    func inputValuesMeetRule(integerCount: Int?, decimalCount: Int?) -> Bool {
        // 只能输入整数
        if let decimalCount = decimalCount, decimalCount == 0, self.contains(".") {
            return false
        }
        
        // 不让任何输入
        if let integerCount = integerCount, integerCount == 0 {
            return false
        }
        
        // 校验输入是否合法，如：123，123.10，0.0123
        var meetRegxOne = "([0][.][0-9]*)|([1-9][0-9]*[.][0-9]*)|([1-9][0-9]*)|()|[0]"
        if let decimalCount = decimalCount, let integerCount = integerCount { // 限制小数点和整数
            meetRegxOne = "([0][.][0-9]{0,\(decimalCount)})|([1-9][0-9]{0,\(integerCount - 1)}[.][0-9]{0,\(decimalCount)})|([1-9][0-9]{0,\(integerCount - 1)})|()|[0]"
        } else if let decimalCount = decimalCount { // 限制小数点
            meetRegxOne = "([0][.][0-9]{0,\(decimalCount)})|([1-9][0-9]*[.][0-9]{0,\(decimalCount)})|([1-9][0-9]*)|()|[0]"
        } else if let integerCount = integerCount { // 限制整数
            meetRegxOne = "([0][.][0-9]*)|([1-9][0-9]{0,\(integerCount - 1)}[.][0-9]*)|([1-9][0-9]{0,\(integerCount - 1)})|()|[0]"
        }
        let characterSet = NSPredicate.init(format: "SELF MATCHES %@", meetRegxOne)
        if characterSet.evaluate(with: self) == true {
            return true
        }
        return false
    }
}
