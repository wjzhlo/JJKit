//
//  UIButtonExtension.swift
//  JJKit
//
//  Created by Jero on 2022/11/14.
//

import UIKit

extension UIButton {

    /// Runtime存储管理属性
    private struct RuntimeKey {
        static let edgeInsetsKey = UnsafeRawPointer.init(bitPattern: "RuntimeKeyEdgeInsets".hashValue)
        static let lastTimeKey = UnsafeRawPointer.init(bitPattern: "RuntimeKeyLastTime".hashValue)
        static let eventTimeKey = UnsafeRawPointer.init(bitPattern: "RuntimeKeyEventTime".hashValue)
    }
    
    /// 拓展点击区域（通过半径统一设置）
    public var extendedClickAreaRadius: Double {
        get { 0.0 }
        set { extendedClickAreaInsets = UIEdgeInsets(top: -newValue, left: -newValue, bottom: -newValue, right: -newValue) }
    }
    
    ///  拓展点击区域（上下左右逐个设置）
    public var extendedClickAreaInsets: UIEdgeInsets {
        get {
            objc_getAssociatedObject(self, RuntimeKey.edgeInsetsKey!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.edgeInsetsKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 获取点击坐标，调整事件响应的视图
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (extendedClickAreaInsets == UIEdgeInsets.zero) || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }
        else {
            let expandArea = self.bounds.inset(by: extendedClickAreaInsets)
            return expandArea.contains(point)
        }
    }
    
    /// 设置事件响应间隔
    public var eventTimeInterval: TimeInterval {
        get {
            objc_getAssociatedObject(self, RuntimeKey.eventTimeKey!) as? TimeInterval ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.eventTimeKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 存储最后一次点击的时间戳
    private var lastTimeInterval: TimeInterval {
        get {
            objc_getAssociatedObject(self, RuntimeKey.lastTimeKey!) as? TimeInterval ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.lastTimeKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 传递点击事件
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        // 未设置点击间隔
        if eventTimeInterval <= 0 {
            super.sendAction(action, to: target, for: event)
        } else {
            // 获取当前时间
            let currentTimeInterval = Date().timeIntervalSince1970
            // 当前时间与上次点击时间间隔超过设置的间隔时间，允许点击实现响应
            if currentTimeInterval - lastTimeInterval > eventTimeInterval {
                super.sendAction(action, to: target, for: event)
            }
            // 更新最后点击时间
            lastTimeInterval = currentTimeInterval;
        }
    }
}
