//
//  JJToast.swift
//  JJKit
//
//  Created by digis on 2022/11/14.
//

import UIKit

public class JJToast {
    
    ///  单利
    static let share = JJToast()
    private init() { }
    private let activityTag = 1999
    
    /// 父视图底色
    var bottomColor = UIColor.clear
    /// 背景图片
    var bgImage: UIImage?
    /// 背景色
    var bgColor = UIColor(white: 0, alpha: 0.7)
    /// 背景圆角
    var bgCornerRadius = 15.0
    /// 字号大小
    var textFont = UIFont.systemFont(ofSize: 15)
    /// 文本颜色
    var textColor = UIColor.white
    /// 文本提示最小显示时长
    var minShowTime = 1.0
    /// 文本提示最大显示时长
    var maxShowTime = 5.0
    /// 禁用背景的事件响应。若为 false ，则显示在 Toast 背景下的控件会响应事件传递。例：按钮允许点击、列表允许滑动
    var disableBackgroundResponder = true
}

public extension JJToast {
    
    /// 显示Toast
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - toView: 显示在哪个视图上。若不传默认是 window
    class func show(_ text: String?, to toView: UIView? = nil) {
        
        guard let text, text.isEmpty == false else { return }
        
        DispatchQueue.main.async {
            
            var bgView = toView
            if bgView == nil { bgView = getWindow() }
            guard let bgView else { return }
            
            let (toastBgView, toastView, imageView, textLabel) = createToast(toView: bgView, text: text)
            let parentSize = toastBgView.superview?.size ?? UIScreen.main.bounds.size
            let textSize = textLabel.attributedText!.boundingRect(with: CGSize(width: parentSize.width - 80.0, height: 0),
                                                                  options: .usesLineFragmentOrigin,
                                                                  context: nil).size
            let toastSize = CGSize(width: textSize.width + 30.0, height: textSize.height + 30.0)
            
            toastBgView.frame = CGRect(origin: CGPoint.zero, size: parentSize)
            toastView.frame = CGRect(origin: CGPoint.zero, size: toastSize)
            imageView.frame = CGRect(origin: CGPoint.zero, size: toastSize)
            textLabel.frame = CGRect(origin: CGPoint.zero, size: textSize)
            
            toastView.center = CGPoint(x: toastBgView.width/2.0, y: toastBgView.height/2.0)
            imageView.center = CGPoint(x: toastView.width/2.0, y: toastView.height/2.0)
            textLabel.center = CGPoint(x: toastView.width/2.0, y: toastView.height/2.0)
            
            func getLength(_ str: String?) -> Int {
                guard let str = str else { return 0 }
                let cfEncValue = CFStringEncodings.GB_18030_2000.rawValue
                let encValue = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncValue))
                guard let data = str.data(using: String.Encoding(rawValue: encValue)) else { return 0 }
                return data.count
            }
            
            let minimum = max(CGFloat(getLength(text)/2) * 0.06 + 0.5, JJToast.share.minShowTime)
            let delayTime = min(minimum, JJToast.share.maxShowTime)
            
            toastBgView.alpha = 0
            toastBgView.transform = CGAffineTransformMakeScale(0.95, 0.95)
            UIView.animate(withDuration: 0.1) {
                toastBgView.alpha = 0.5
                toastBgView.transform = CGAffineTransformMakeScale(1.05, 1.05)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    toastBgView.alpha = 1
                    toastBgView.transform = CGAffineTransformIdentity
                }
                UIView.animate(withDuration: 0.2, delay: delayTime, options: .curveEaseInOut) {
                    toastBgView.alpha = 0
                    toastBgView.transform = CGAffineTransformMakeScale(0.95, 0.95)
                } completion: { _ in
                    toastBgView.removeFromSuperview()
                    toastBgView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
    
    /// 显示加载动画
    /// - Parameters:
    ///   - toView: 在哪个视图上显示
    ///   - text: 提示的文本
    ///   - closeButton: 关闭按钮
    class func showActivity(to toView: UIView? = nil, text: String? = nil, closeButton: UIButton? = nil) {
        
        DispatchQueue.main.async {
            
            var bgView = toView
            if bgView == nil { bgView = getWindow() }
            guard let bgView else { return }
            
            let (toastBgView, toastView, imageView, textLabel) = createToast(toView: bgView, text: text ?? "")
            let parentSize = toastBgView.superview?.size ?? UIScreen.main.bounds.size
            toastBgView.frame = CGRect(origin: CGPoint.zero, size: parentSize)
            toastBgView.tag = JJToast.share.activityTag
            
            let activitySize = CGSizeMake(105, 105)
            let activityView = UIActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: activitySize))
            activityView.backgroundColor = UIColor.clear
            activityView.style = .large
            activityView.color = UIColor.white
            activityView.startAnimating()
            toastView.addSubview(activityView)
            
            if let text, text.isEmpty == false {
                let textSize = textLabel.attributedText!.boundingRect(with: CGSize(width: parentSize.width - 80.0, height: 0),
                                                                      options: .usesLineFragmentOrigin,
                                                                      context: nil).size
                let toastSize = CGSize(width: max(textSize.width + 30.0, activitySize.width), height: textSize.height + activitySize.height)
                toastView.frame = CGRect(origin: CGPoint.zero, size: toastSize)
                imageView.frame = CGRect(origin: CGPoint.zero, size: toastSize)
                textLabel.frame = CGRect(origin: CGPoint.zero, size: textSize)

                toastView.center = CGPoint(x: toastBgView.width/2.0, y: toastBgView.height/2.0)
                imageView.center = CGPoint(x: toastView.width/2.0, y: toastView.height/2.0)
                textLabel.center = CGPoint(x: toastView.width/2.0, y: toastView.height/2.0 + 30)
                activityView.center = CGPoint(x: toastView.width/2.0, y: activitySize.height/2.0 - 8)
            } else {
                toastView.frame = CGRect(origin: CGPoint.zero, size: activitySize)
                imageView.frame = CGRect(origin: CGPoint.zero, size: activitySize)
                textLabel.frame = CGRect(origin: CGPoint.zero, size: activitySize)
                
                toastView.center = CGPoint(x: toastBgView.width/2.0, y: toastBgView.height/2.0)
            }
            
            if let closeButton {
                toastBgView.addSubview(closeButton)
                closeButton.center = CGPoint(x: toastBgView.width/2.0, y: (toastBgView.height + toastView.height)/2.0 + 45)
            }
            
            toastBgView.alpha = 0
            toastBgView.transform = CGAffineTransformMakeScale(0.95, 0.95)
            UIView.animate(withDuration: 0.1) {
                toastBgView.alpha = 0.5
                toastBgView.transform = CGAffineTransformMakeScale(1.05, 1.05)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    toastBgView.alpha = 1
                    toastBgView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
    
    /// 隐藏加载动画
    /// - Parameter fromView: 从哪个视图上移除
    class func hideActivity(from fromView: UIView? = nil) {
        
        var bgView = fromView
        if bgView == nil { bgView = getWindow() }
        guard let bgView else { return }
        guard let toastBgView = bgView.viewWithTag(JJToast.share.activityTag) else { return }
        
        UIView.animate(withDuration: 0.2) {
            toastBgView.alpha = 0
            toastBgView.transform = CGAffineTransformMakeScale(0.95, 0.95)
        } completion: { _ in
            toastBgView.removeFromSuperview()
            toastBgView.transform = CGAffineTransformIdentity
        }
    }
}

private extension JJToast {
    
    /// 获取 window 视图
    class func getWindow() -> UIView? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
    }
    
    /// 创建 Toast 基本视图组成
    /// - Parameters:
    ///   - toView: 显示在哪个 view 上
    ///   - text: 显示的文本
    /// - Returns: 依次返回：toastBgView, toastView, imageView, textLabel
    class func createToast(toView: UIView, text: String) -> (UIView, UIView, UIImageView, UILabel) {
        
        let toastBgView = UIView()
        toastBgView.backgroundColor = JJToast.share.bottomColor
        toastBgView.isUserInteractionEnabled = JJToast.share.disableBackgroundResponder
        toView.addSubview(toastBgView)
        
        let toastView = UIView()
        toastView.backgroundColor = JJToast.share.bgColor
        toastView.layer.cornerRadius = JJToast.share.bgCornerRadius
        toastView.layer.masksToBounds = true
        toastBgView.addSubview(toastView)

        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = JJToast.share.bgImage
        toastView.addSubview(imageView)
        
        let textLabel = UILabel()
        textLabel.backgroundColor = UIColor.clear
        textLabel.numberOfLines = 0
        toastView.addSubview(textLabel)
        
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = 5.0
        
        let mStr = NSMutableAttributedString(string: text)
        mStr.addAttribute(.paragraphStyle, value: pStyle, range: NSMakeRange(0, mStr.length))
        mStr.addAttribute(.font, value: JJToast.share.textFont, range: NSMakeRange(0, mStr.length))
        mStr.addAttribute(.foregroundColor, value: JJToast.share.textColor, range: NSMakeRange(0, mStr.length))
        textLabel.attributedText = mStr
        
        return (toastBgView, toastView, imageView, textLabel)
    }
}
