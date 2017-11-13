//
//  MGCNavigationControllerViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/22/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class MGCNavigationControllerViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = #colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 1)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : #colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 1)]
        
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(statusView)
    }
}
