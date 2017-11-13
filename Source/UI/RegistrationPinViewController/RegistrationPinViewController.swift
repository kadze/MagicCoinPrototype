//
//  RegistrationPinViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/24/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class RegistrationPinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- Actions
    
    @IBAction func onRegistrationButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
