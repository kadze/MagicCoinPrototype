//
//  UIView+Nib.swift
//  MagicCoin
//
//  Created by ASH on 8/2/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return view
    }
}
