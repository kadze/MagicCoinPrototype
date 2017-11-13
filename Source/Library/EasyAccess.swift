//
//  EasyAccess.swift
//  HoloArts
//
//  Created by Oleh Korchytskyi on 03/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

protocol EasyNibAccess: class {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension EasyNibAccess {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

protocol EasyViewAccess {
    static var view: UIView { get }
}

protocol EasyCellAccess: EasyViewAccess {
    static var cell: Self { get }
}

extension EasyViewAccess where Self: EasyNibAccess {
    static var view: UIView {
        return (nib.instantiate(withOwner: nil, options: nil) as! [UIView]).first!
    }
}

extension EasyCellAccess {
    static var cell: Self {
        return view as! Self
    }
}

extension UITableViewCell:              EasyNibAccess { }
extension UICollectionViewCell:         EasyNibAccess { }
extension UITableViewHeaderFooterView:  EasyNibAccess { }

extension UITableViewCell:              EasyViewAccess { }
extension UICollectionViewCell:         EasyViewAccess { }

extension UITableView {
    func dequeCellOf<T>(type: T.Type) -> T? where T: EasyNibAccess {
        return dequeueReusableCell(withIdentifier: T.nibName) as? T
    }
    
    func dequeHeader<T>(type: T.Type) -> T? where T: EasyNibAccess {
        return dequeueReusableHeaderFooterView(withIdentifier: T.nibName) as? T
    }
}

extension UICollectionView {
    func dequeCellOf<T>(type: T.Type, indexPath: IndexPath) -> T? where T: EasyNibAccess {
        return dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T
    }
}
