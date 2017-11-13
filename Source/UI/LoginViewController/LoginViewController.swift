//
//  LoginViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/22/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Actions
    
    @IBAction func onLoginButton(_ sender: Any) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    @IBAction func onForgotPinButton(_ sender: Any) {
        
    }
}
