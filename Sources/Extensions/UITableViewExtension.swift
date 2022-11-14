//
//  UITableViewExtension.swift
//  JJKit
//
//  Created by Jero on 2022/11/14.
//

import UIKit

public extension UITableView {
    
    /// Cell register and reuse
    func registerCellNib<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
    
    func registerCellClass<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    /// HeaderFooter register and reuse
    func registerHeaderFooterNib<T: UIView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func registerHeaderFooterClass<T: UIView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func dequeueReusableHeaderFooter<T: UIView>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}
