//
//  ViewController.swift
//  VerifyCodeDemo
//
//  Created by tuandai on 2019/1/30.
//  Copyright © 2019 tuandai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var codeView: TDWVerifyCodeView = {
        let codeView = TDWVerifyCodeView.init(inputTextNum: 6)
        codeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(codeView)
        return codeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let codeViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[codeView]|", options: .directionMask, metrics: nil, views: ["codeView":codeView])
        let codeViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-250-[codeView(35)]", options: .directionMask, metrics: nil, views: ["codeView":codeView])
        codeView.superview?.addConstraints(codeViewH)
        codeView.superview?.addConstraints(codeViewV)
        
        codeView.textFiled.becomeFirstResponder()
        
        // 监听验证码输入的过程
        codeView.textValueChange = { str in
            // 要做的事情
        }
        
        // 监听验证码输入完成
        codeView.inputFinish = { str in
            // 要做的事情
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

