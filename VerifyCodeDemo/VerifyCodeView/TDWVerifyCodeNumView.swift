//
//  TDWVerifyCodeNumView.swift
//  VerifyCodeDemo
//
//  Created by tuandai on 2019/1/30.
//  Copyright © 2019 tuandai. All rights reserved.
//

import UIKit

class TDWVerifyCodeNumView: UIView {
    
    /// 光标颜色
    var cursorColor = UIColor.init(TDWValueRGB: 0xfab700)
    
    fileprivate lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(TDWValueRGB: 0xe6e6e6)
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(line)
        return line
    }()
    
    /// 光标
    lazy var cursor: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = cursorColor.cgColor
        shapeLayer.add(opacityAnimation, forKey: "kOpacityAnimation")
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    /// 闪烁动画
    fileprivate var opacityAnimation: CABasicAnimation = {
        let opacityAnimation = CABasicAnimation.init(keyPath: "opacity")
        // 属性初始值
        opacityAnimation.fromValue = 1.0
        // 属性要到达的值
        opacityAnimation.toValue = 0.0
        // 动画时间
        opacityAnimation.duration = 0.9
        // 重复次数(无穷大)
        opacityAnimation.repeatCount = HUGE
        /*
         removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards
         */
        opacityAnimation.isRemovedOnCompletion = true
        // 决定当前对象在非active时间段的行为。比如动画开始之前或者动画结束之后
        opacityAnimation.fillMode = kCAFillModeForwards
        // 速度控制函数，控制动画运行的节奏
        /*
         kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
         kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
         kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
         kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。
         */
        opacityAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        return opacityAnimation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let numLabelH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[numLabel]|", options: .directionMask, metrics: nil, views: ["numLabel":numLabel])
        let numLabelV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[numLabel]-0.5-|", options: .directionMask, metrics: nil, views: ["numLabel":numLabel])
        numLabel.superview?.addConstraints(numLabelH)
        numLabel.superview?.addConstraints(numLabelV)
        
        let lineViewH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: .directionMask, metrics: nil, views: ["lineView":lineView])
        let lineViewV = NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(0.5)]|", options: .directionMask, metrics: nil, views: ["lineView":lineView])
        lineView.superview?.addConstraints(lineViewH)
        lineView.superview?.addConstraints(lineViewV)
        
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBack), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath.init(rect: CGRect.init(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.1, width: 1, height: self.frame.size.height * 0.7))
        cursor.path = path.cgPath
    }
    
    /// 去后台
    @objc fileprivate func enterBack() {
        // 移除动画
        cursor.removeAnimation(forKey: "kOpacityAnimation")
    }
    
    /// 回前台
    @objc fileprivate func becomeActive() {
        // 重新添加动画
        cursor.add(opacityAnimation, forKey: "kOpacityAnimation")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 供外部调用方法
extension TDWVerifyCodeNumView {
    /// 设置光标是否隐藏
    ///
    /// - Parameter isHidden: 是否隐藏
    func setCursorStatus(_ isHidden: Bool) {
        if isHidden {
            cursor.removeAnimation(forKey: "kOpacityAnimation")
        } else {
            cursor.add(opacityAnimation, forKey: "kOpacityAnimation")
        }
        UIView.animate(withDuration: 0.25) {
            self.cursor.isHidden = isHidden
        }
    }
    
    /// 验证码赋值，并修改线条颜色
    ///
    /// - Parameter num: 验证码
    func setNum(num: String?) {
        numLabel.text = num
    }
    
    /// 设置底部线条是否为焦点
    ///
    /// - Parameter isFocus: 是否是焦点
    func setBottomLineFocus(isFocus: Bool) {
        if isFocus {
            lineView.backgroundColor = UIColor.init(TDWValueRGB: 0x999999)
        } else {
            lineView.backgroundColor = UIColor.init(TDWValueRGB: 0xe6e6e6)
        }
    }
    
    /// 获取当前的验证码
    ///
    /// - Returns: 验证码
    func getNum() -> String {
        return numLabel.text ?? ""
    }
    
    /// 返回验证码值
    ///
    /// - Returns: 验证码数值
    func getNum() -> String? {
        return numLabel.text
    }
}
