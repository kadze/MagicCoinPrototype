//
//  HomeViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/26/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lastTransactionDirectionImageView: UIImageView!
    @IBOutlet weak var lastTransactionSumLabel: UILabel!
    @IBOutlet weak var lastTransactionDescriptionLabel: UILabel!
    
    var activeVouchers = [Voucher]()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationItem()
        
        collectionView.register(ActiveVoucherCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ActiveVoucherCollectionViewCell.nibName)
        
        setupScreenEdgePanGestureRecognizer()
        
        fillVouchers()
    }

    //MARK: - Actions
    
    @IBAction func onScanQRButton(_ sender: UIButton) {
        present(QRCodeScannerViewController(), animated: true, completion: nil)
    }
    
    @IBAction func onLastTransactionButton(_ sender: Any) {
        self.showTransactions()
    }
    
    @IBAction func onArchiveButton(_ sender: UIButton) {
        let vouchersController = VouchersViewController()
        vouchersController.selectedPage = .archive
        navigationController?.pushViewController(vouchersController, animated: true)
    }
    
    func onMenuButton(_sender: UIBarButtonItem) {
        showMenu()
    }
    
    func onMapButton(_sender: UIBarButtonItem) {
        self.showLocations()
    }
    
    // MARK: - UIScreenEdgePanGestureRecognizer
    
    func didPanWith(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            showMenu()
            
            break
        default:
            break
        }
    }
    
    //MARK: - Private
    
    private func customizeNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MenuButton"), style: .plain, target: self, action: #selector(onMenuButton(_sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MapButton"), style: .plain, target: self, action: #selector(onMapButton(_sender:)))
        for item in [navigationItem.leftBarButtonItem, navigationItem.rightBarButtonItem] {
            item?.tintColor = #colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 1)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    private func fillVouchers() {
        let starbucksVoucher = Voucher(active: true, balance: 2200, image: UIImage(named:"starbucks@2x")!, title: "Starbucks", validDate: Date())
        let tawandangVoucher = Voucher(active: true, balance: 10000, image: UIImage(named:"tawandang@2x")!, title: "Tawandang", validDate: Date())
        let majaorVoucher = Voucher(active: true, balance: 2200, image: UIImage(named:"majaor@2x")!, title: "Majaor CinePlex", validDate: Date())
        
        activeVouchers = [starbucksVoucher, tawandangVoucher, majaorVoucher]
    }
    
    private func setupScreenEdgePanGestureRecognizer() {
        let edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didPanWith(recognizer:)))
        edgePanRecognizer.edges = .left
        view.addGestureRecognizer(edgePanRecognizer)
    }
    
    private func showMenu() {
        let menuController = MenuViewController()
        
        menuController.presentVouchers = {[unowned self] in
            self.navigationController?.pushViewController(VouchersViewController(), animated: true)
        }
        
        menuController.presentTransactions = {[unowned self] in
            self.showTransactions()
        }
        
        menuController.presentLocations = {[unowned self] in
            self.showLocations()
        }
        
        menuController.logOut = {[unowned self] in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let transitioningDelegate = SideMenuPresentationManager()
        transitioningDelegate.mode = .RightSpace(70)
        menuController.transitioningDelegate = transitioningDelegate
        menuController.modalPresentationStyle = .custom
        
        present(menuController, animated: true, completion: nil)
    }
    
    private func showLocations() {
        navigationController?.pushViewController(LocationsViewController(), animated: true)
    }
    
    private func showTransactions() {
        navigationController?.pushViewController(TransactionsViewController(), animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeVouchers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeCellOf(type: ActiveVoucherCollectionViewCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.model = activeVouchers[indexPath.row]
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(VouchersViewController(), animated: true)
    }
}

