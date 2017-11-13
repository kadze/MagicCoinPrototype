//
//  RegistrationViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/24/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    //MARK: - Actions
    @IBAction func onNextButton(_ sender: Any) {
        navigationController?.pushViewController(RegistrationPinViewController(), animated: true)
    }
}
