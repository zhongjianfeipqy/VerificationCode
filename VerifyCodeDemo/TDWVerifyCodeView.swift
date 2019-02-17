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
    lazy var textView: TDWVerifyCodeTextView = {
        let textView = TDWVerifyCodeTextView()
        textView.tintColor = .clear
        textView.backgroundColor = .clear
        textView.textColor = .clear
        textView.delegate = self
        textView.keyboardType = .decimalPad
        self.addSubview(textView)
        return textView
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
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.top.bottom.equalToSuperview()
        }
        
        // 每个验证码框宽度
        let itemWidth: CGFloat = (UIScreen.tdw_width() - padding * 2 - spacing * (CGFloat(inputTextNum) - 1)) / CGFloat(inputTextNum)
        for i in 0..<inputTextNum {
            let codeNumView = TDWVerifyCodeNumView()
            codeNumView.isUserInteractionEnabled = false
            self.addSubview(codeNumView)
            codeNumView.snp.makeConstraints { (make) in
                make.width.equalTo(itemWidth)
                make.left.equalToSuperview().offset(padding + CGFloat(i) * (spacing + itemWidth))
                make.top.bottom.equalToSuperview()
            }
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
        textView.text = ""
        textViewDidChange(textView)
        allCursorHidden()
    }
    
    /// 隐藏所有输入光标
    func allCursorHidden() {
        DispatchQueue.main.async {
            for i in 0..<self.codeViews.count {
                let codeView = self.codeViews[i]
                codeView.setCursorStatus(true)
            }
        }
    }
}

// MARK: - 键盘显示隐藏
extension TDWVerifyCodeView {
    
    @objc fileprivate func keyboardShow(note: Notification) {
        isInput = false
        textViewDidChange(textView)
        isInput = true
    }
    
    @objc fileprivate func keyboardHidden(note: Notification) {
        allCursorHidden()
    }
}

// MARK: - UITextViewDelegate
extension TDWVerifyCodeView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 输入框已有的值
        var inputText = textView.text ?? ""
        
        if text.count == 0 { // 删除
            if range.location != inputText.count - 1 { // 删除的不是最后一个
                if inputText.count > 0 {
                    // 手动删除最后一位
                    textView.text.removeLast()
                    textViewDidChange(textView)
                }
                return false
            }
        }
        
        if let tempRange = Range.init(range, in: inputText) {
            // 拼接输入后的值
            inputText = inputText.replacingCharacters(in: tempRange , with: text)
            let isMeet = inputText.inputValuesMeetRule(integerCount: nil, decimalCount: 0)
            if isMeet == false {
                return isMeet
            }
        }
        
        if inputText.count > inputTextNum {
            
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let inputStr = textView.text ?? ""
        
        textValueChange?(inputStr)
        
        for i in 0..<codeViews.count {
            let codeView = codeViews[i]
            if i < inputStr.count {
                codeView.setNum(num: inputStr[String.Index.init(encodedOffset: i)].description)
                codeView.setCursorStatus(true)
            } else {
                codeView.setNum(num: nil)
                if inputStr.count == 0, i == 0 {
                    codeView.setCursorStatus(false)
                } else {
                    codeView.setCursorStatus(i != inputStr.count)
                }
            }
        }
        
        if isInput, inputStr.count >= inputTextNum {
            // 结束编辑
            DispatchQueue.main.async {
                textView.resignFirstResponder()
            }
            inputFinish?(inputStr)
            allCursorHidden()
        }
        
    }
}
