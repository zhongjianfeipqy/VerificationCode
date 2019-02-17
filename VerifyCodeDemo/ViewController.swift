//
//  ViewController.swift
//  VerifyCodeDemo
//
//  Created by tuandai on 2019/1/30.
//  Copyright © 2019 tuandai. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    lazy var codeView: TDWVerifyCodeView = {
        let codeView = TDWVerifyCodeView.init(inputTextNum: 6)
        self.view.addSubview(codeView)
        return codeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
        codeView.textView.becomeFirstResponder()
        
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

