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
    /// 最小显示时长
    var minShowTime = 1.0
    /// 最大显示时长
    var maxShowTime = 5.0
}

extension JJToast {
    
    /// 显示Toast
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - targetView: 显示在哪个视图上。若不传默认是 window
    public class func show(_ text: String?, on targetView: UIView? = nil) {
        
        guard let text, text.isEmpty == false else { return }

        DispatchQueue.main.async {
                        
            var parentView = targetView
            if parentView == nil {
                parentView = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
            }
            guard let parentView else { return }
            
            let toastBgView = UIView()
            toastBgView.backgroundColor = JJToast.share.bottomColor
            parentView.addSubview(toastBgView)
            
            let toastView = UIView()
            toastView.backgroundColor = JJToast.share.bgColor
            toastView.layer.cornerRadius = JJToast.share.bgCornerRadius
            toastView.layer.masksToBounds = true
            toastBgView.addSubview(toastView)

            let imageView = UIImageView()
            imageView.image = JJToast.share.bgImage
            imageView.backgroundColor = UIColor.clear
            toastView.addSubview(imageView)
            
            let textLabel = UILabel()
            textLabel.numberOfLines = 0
            toastView.addSubview(textLabel)
            
            let pStyle = NSMutableParagraphStyle()
            pStyle.lineSpacing = 5.0
            
            let mStr = NSMutableAttributedString(string: text)
            mStr.addAttribute(.paragraphStyle, value: pStyle, range: NSMakeRange(0, mStr.length))
            mStr.addAttribute(.font, value: JJToast.share.textFont, range: NSMakeRange(0, mStr.length))
            mStr.addAttribute(.foregroundColor, value: JJToast.share.textColor, range: NSMakeRange(0, mStr.length))
            textLabel.attributedText = mStr
            
            let parentSize = toastBgView.superview?.size ?? UIScreen.main.bounds.size
            let textSize = mStr.boundingRect(with: CGSize(width: parentSize.width - 80.0, height: 0), options: .usesLineFragmentOrigin, context: nil).size
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
            toastView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            UIView.animate(withDuration: 0.1) {
                toastBgView.alpha = 0.5
                toastView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    toastBgView.alpha = 1
                    toastView.transform = CGAffineTransformIdentity
                }
                UIView.animate(withDuration: 0.2, delay: delayTime, options: .curveEaseInOut) {
                    toastBgView.alpha = 0
                    toastView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                } completion: { _ in
                    toastBgView.removeFromSuperview()
                    toastView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
}
