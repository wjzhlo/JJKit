//
//  UICollectionViewExtension.swift
//  JJKit
//
//  Created by Jero on 2022/11/14.
//

import UIKit

public extension UICollectionView {
    
    /// Cell register and reuse
    func registerCellNib<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellWithReuseIdentifier: name)
    }

    func registerCellClass<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellWithReuseIdentifier: name)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ aClass: T.Type, for indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    /// Supplementary view register and reuse
    func elementKind(isHeader: Bool) -> String {
        let ofKind = isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
        return ofKind
    }
    
    func registerSupplementaryNib<T: UICollectionReusableView>(_ aClass: T.Type, isHeader: Bool) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forSupplementaryViewOfKind: elementKind(isHeader: isHeader), withReuseIdentifier: name)
    }
    
    func registerSupplementaryClass<T: UICollectionReusableView>(_ aClass: T.Type, isHeader: Bool) {
        let name = String(describing: aClass)
        register(aClass, forSupplementaryViewOfKind: elementKind(isHeader: isHeader), withReuseIdentifier: name)
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(_ aClass: T.Type, isHeader: Bool, for indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableSupplementaryView(ofKind: elementKind(isHeader: isHeader), withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}
