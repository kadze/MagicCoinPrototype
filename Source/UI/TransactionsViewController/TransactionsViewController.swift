//
//  TransactionsViewController.swift
//  MagicCoin
//
//  Created by ASH on 8/1/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let controllerTitle = "Transactions"
    let navBarHeitht: CGFloat = 44
    let statusBarHeight: CGFloat = 20
    
    var transactions = [Transaction]()
    var dataSource: TableDataSource<TransactionTableViewCell, Transaction>!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customozeNavigationItem()
        setupTableView()
        fillTransactons()
        updateTableView()
    }

    //MARK: - Private
    
    private func customozeNavigationItem() {
        title = controllerTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"), style: .plain, target: self, action: nil)
    }
    
    private func updateTableView() {
        self.dataSource = TableDataSource(cellIdentifier: TransactionTableViewCell.nibName, items: transactions, configureCell: { (cell, transaction) in
            cell.model = transaction
        })
        
        tableView.dataSource = self.dataSource
        tableView.reloadData()
    }
    
    private func fillTransactons() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        let acceptVoucher = Voucher(active: true, balance: 0, image: #imageLiteral(resourceName: "AcceptingCoins"), title: "Accepting coins", validDate: Date())
        
        transactions = [
            Transaction(direction: .income,
                        voucher: acceptVoucher,
                        sum: 102230,
                        date: formatter.date(from: "12.02.2017 23:05")!,
                        terminal: "Terminal #23133, Bangkok, 261 Soi Chan 23/2"),

            Transaction(direction: .outcome,
                        voucher: Voucher(active: true, balance: 0, image: UIImage(named:"starbucks@2x")!, title: "Starbucks", validDate: Date()),
                        sum: 200000,
                        date: formatter.date(from: "12.02.2017 23:04")!,
                        terminal: "Terminal #23133, Bangkok, 261 Soi Chan 23/2"),
            
            Transaction(direction: .income,
                        voucher: acceptVoucher,
                        sum: 1241220,
                        date: formatter.date(from: "12.02.2017 23:03")!,
                        terminal: "Terminal #23133, Bangkok, 261 Soi Chan 23/2"),
            
            Transaction(direction: .outcome,
                        voucher: Voucher(active: true, balance: 0, image: UIImage(named:"tawandang@2x")!, title: "Tawandang", validDate: Date()),
                        sum: 900000,
                        date: formatter.date(from: "12.02.2017 23:02")!,
                        terminal: "Terminal #23133, Bangkok, 261 Soi Chan 23/2"),
            
            Transaction(direction: .outcome,
                        voucher: Voucher(active: true, balance: 0, image: UIImage(named:"majaor@2x")!, title: "Majaor CinePlex", validDate: Date()),
                        sum: 200000,
                        date: formatter.date(from: "12.02.2017 23:01")!,
                        terminal: "Terminal #23133, Bangkok, 261 Soi Chan 23/2")
        ]
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsetsMake(navBarHeitht + statusBarHeight, 0, 0, 0)
        tableView.register(TransactionTableViewCell.nib, forCellReuseIdentifier: TransactionTableViewCell.nibName)
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
