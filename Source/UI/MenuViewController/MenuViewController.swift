//
//  MenuViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/31/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var presentVouchers: (()->())?
    var presentTransactions: (()->())?
    var presentLocations: (()->())?
    var logOut:(()->())?

    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    @IBAction func onHomeButton(_ sender: UIButton) {
        hideMenu()
    }
    
    @IBAction func onVouchersButton(_ sender: UIButton) {
        hideMenu(completion: {[weak self] in
            if let weakSelf = self,
                let presentVouchers = weakSelf.presentVouchers
            {
                presentVouchers()
            }
        })
    }
    
    @IBAction func onTransactionsButton(_ sender: UIButton) {
        hideMenu(completion: {[weak self] in
            if let weakSelf = self,
                let presentTransactoins = weakSelf.presentTransactions
            {
                presentTransactoins()
            }
        })
    }
    
    @IBAction func onAchievementsButton(_ sender: UIButton) {
        
    }
    
    @IBAction func onLocationsButton(_ sender: UIButton) {
        hideMenu(completion: {[weak self] in
            if let weakSelf = self,
                let presentLocations = weakSelf.presentLocations
            {
                presentLocations()
            }
        })
    }
    
    @IBAction func onLogOutButton(_ sender: UIButton) {
        hideMenu(completion: {[weak self] in
            if let weakSelf = self,
                let logOut = weakSelf.logOut
            {
                logOut()
            }
        })
    }
    
    //MARK: - Private
    
    private func hideMenu(completion: (() -> Swift.Void)? = nil) {
        let transitioningDelegate = SideMenuPresentationManager()
        transitioningDelegate.mode = .RightSpace(70)
        self.transitioningDelegate = transitioningDelegate
        self.modalPresentationStyle = .custom
        self.dismiss(animated: true, completion: completion)
    }
    
}
