//
//  TDWVerifyCodeView.swift
//  VerifyCodeDemo
//
//  Created by tuandai on 2019/1/30.
//  Copyright © 2019 tuandai. All rights reserved.
//

import UIKit

class TDWVerifyCodeView: UIView {

    /// 输入值改变
    var textValueChange: ((_ text: String) -> Void)?
    
    /// 输入完成
    var inputFinish: ((_ text: String) -> Void)?
    
    /// 验证码输入框个数
    var inputTextNum: Int = 6
    
    /// 输入框
    lazy var textFiled: TDWVerifyCodeTextView = {
        let textFiled = TDWVerifyCodeTextView()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = .clear
        textFiled.textColor = .clear
        textFiled.delegate = self
        textFiled.keyboardType = .decimalPad
        textFiled.addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFiled)
        return textFiled
    }()
    
    /// 验证码数量
    var codeViews: [TDWVerifyCodeNumView] = []
    
    /// 验证码输入框距离两边的边距
    var padding: CGFloat = 15
    
    /// 每个验证码输入框间距
    var spacing: CGFloat = 10
    
    /// 是否在输入中
    var isInput = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(inputTextNum: Int) {
        self.init()
        self.inputTextNum = inputTextNum
        initSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func initSubviews() {
        let textFiledH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[textFiled]-padding-|", options: .directionMask, metrics: ["padding":padding], views: ["textFiled":textFiled])
        let textFiledV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[textFiled]|", options: .directionMask, metrics: nil, views: ["textFiled":textFiled])
        textFiled.superview?.addConstraints(textFiledH)
        textFiled.superview?.addConstraints(textFiledV)
        
        // 每个验证码框宽度
        let itemWidth: CGFloat = (UIScreen.tdw_width() - padding * 2 - spacing * (CGFloat(inputTextNum) - 1)) / CGFloat(inputTextNum)
        for i in 0..<inputTextNum {
            let codeNumView = TDWVerifyCodeNumView()
            codeNumView.translatesAutoresizingMaskIntoConstraints = false
            codeNumView.isUserInteractionEnabled = false
            self.addSubview(codeNumView)
            let codeNumViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-m-[codeNumView(itemWidth)]", options: .directionMask, metrics: ["itemWidth":itemWidth, "m": padding + CGFloat(i) * (spacing + itemWidth)], views: ["codeNumView":codeNumView])
            let codeNumViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[codeNumView]|", options: .directionMask, metrics: nil, views: ["codeNumView":codeNumView])
            codeNumView.superview?.addConstraints(codeNumViewH)
            codeNumView.superview?.addConstraints(codeNumViewV)
            codeViews.append(codeNumView)
            codeNumView.setCursorStatus(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 供外部调用方法
extension TDWVerifyCodeView {
    /// 清除所有输入
    func cleanCodes() {
        textFiled.text = ""
        textFiledDidChange(textFiled)
        allCursorHidden()
    }
    
    /// 隐藏所有输入光标
    func allCursorHidden() {
        DispatchQueue.main.async {
            for i in 0..<self.codeViews.count {
                let codeView = self.codeViews[i]
                codeView.setCursorStatus(true)
                if codeView.getNum().count == 0 {
                    codeView.setBottomLineFocus(isFocus: false)
                }
            }
        }
    }
}

// MARK: - 键盘显示隐藏
extension TDWVerifyCodeView {
    
    @objc fileprivate func keyboardShow(note: Notification) {
        isInput = false
        textFiledDidChange(textFiled)
        isInput = true
    }
    
    @objc fileprivate func keyboardHidden(note: Notification) {
        allCursorHidden()
    }
}

// MARK: - UITextViewDelegate
extension TDWVerifyCodeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 输入框已有的值
        var inputText = textFiled.text ?? ""
        
        if string.count == 0 { // 删除
            if range.location != inputText.count - 1 { // 删除的不是最后一个
                if inputText.count > 0 {
                    // 手动删除最后一位
                    textFiled.text?.removeLast()
                    textFiledDidChange(textFiled)
                }
                return false
            }
        }
        
        if let tempRange = Range.init(range, in: inputText) {
            // 拼接输入后的值
            inputText = inputText.replacingCharacters(in: tempRange , with: string)
            let meetRegx = "[0-9]*"         
            let characterSet = NSPredicate.init(format: "SELF MATCHES %@", meetRegx)
            if characterSet.evaluate(with: inputText) == false {
                return false
            }
        }
        
        if inputText.count > inputTextNum {
            
            return false
        }
        
        return true
    }
    
    @objc func textFiledDidChange(_ textFiled: UITextField) {
        let inputStr = textFiled.text ?? ""
        
        textValueChange?(inputStr)
        
        for i in 0..<codeViews.count {
            let codeView = codeViews[i]
            if i < inputStr.count {
                codeView.setNum(num: inputStr[String.Index.init(encodedOffset: i)].description)
                codeView.setBottomLineFocus(isFocus: true)
                codeView.setCursorStatus(true)
            } else {
                if inputStr.count == 0, i == 0 {
                    codeView.setCursorStatus(false)
                    codeView.setBottomLineFocus(isFocus: true)
                    codeView.setNum(num: nil)
                } else {
                    codeView.setCursorStatus(i != inputStr.count)
                    codeView.setNum(num: nil)
                    codeView.setBottomLineFocus(isFocus: i == inputStr.count)
                }
            }
        }
        
        if isInput, inputStr.count >= inputTextNum {
            // 结束编辑
            DispatchQueue.main.async {
                textFiled.resignFirstResponder()
            }
            inputFinish?(inputStr)
            allCursorHidden()
        }
        
    }
}
