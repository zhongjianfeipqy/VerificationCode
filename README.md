# VerificationCode

## 效果：
![验证码输入Demo.gif](https://upload-images.jianshu.io/upload_images/2094754-768de1c89184e230.gif?imageMogr2/auto-orient/strip)


## 思路：
视图层级：


- 最底层一个隐藏的UITextView，上面铺的Label

- 输入焦点在UITextView，监听UITextView的输入，给Label赋值

- 通过Label显示输入的文字使用CAShapeLayer绘制光标

- 通过光标的显示隐藏来控制光标的移动

- 基础动画控制光标闪动



## 使用：
### 初始化：
          // 初始化验证码输入框数量
        TDWVerifyCodeView.init(inputTextNum: 6)
    
    
         // 监听验证码输入的过程
        codeView.textValueChange = { [weak self] str in
            // 要做的事情
        }
        
        // 监听验证码输入完成
        codeView.inputFinish = { [weak self] str in
            // 要做的事情
        }
###
