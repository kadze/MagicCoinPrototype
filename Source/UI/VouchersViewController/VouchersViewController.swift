//
//  VouchersViewController.swift
//  MagicCoin
//
//  Created by ASH on 8/1/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

enum VouchersPage {
    case active
    case promo
    case archive
}

class VouchersViewController: UIViewController {
    
    enum SegmentIndex: Int {
        case active
        case promo
        case archive
        case count
        
        static func titleFor(enumCase :SegmentIndex) -> String {
            switch enumCase {
            case .active:
                return "Active"
            case .promo:
                return "Promo"
            case .archive:
                return "Archive"
            default:
                return ""
            }
        }
    }

    @IBOutlet var tableView: UITableView?
    @IBOutlet var segmentedView: MGCSegmentedControl?
    
    let controllerTitle = "Vouchers"
    
    var vouchers = [Voucher]()
    var dataSource: TableDataSource<VouchersTableViewCell, Voucher>!
    
    var selectedPage: VouchersPage = .active {
        didSet {
            if oldValue != selectedPage {
                updateTableForSelectedPage()
            }
        }
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationItem()
        setupSegmentedView()
        setupTableView()
        setupCounters()
        updateTableForSelectedPage()
    }
    
    //MARK: - Private
    
    private func customizeNavigationItem() {
        title = controllerTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Gift"), style: .plain, target: self, action: nil)
        
        //for the next controller in navigationController stack
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        tableView?.register(VouchersTableViewCell.nib, forCellReuseIdentifier: VouchersTableViewCell.nibName)
    }
    
    private func fillVouchers() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        vouchers = [
            Voucher(active: true, balance: 2200, image: UIImage(named:"starbucks@2x")!, title: "Starbucks", validDate: formatter.date(from: "23.03.2018")!),
            Voucher(active: true, balance: 1100, image: UIImage(named:"starbucks@2x")!, title: "Starbucks", validDate: formatter.date(from: "25.12.2017")!),
            Voucher(active: true, balance: 10000, image: UIImage(named:"tawandang@2x")!, title: "Tawandang", validDate: formatter.date(from: "02.11.2017")!),
            Voucher(active: true, balance: 2100, image: UIImage(named:"tawandang@2x")!, title: "Majaor Cineplex", validDate: formatter.date(from: "25.12.2017")!)
        ]
    }
    
    fileprivate func fillActiveVouchers() {
        fillVouchers()
        segmentedView?.setCounter(text: String(vouchers.count), forButtonAt: SegmentIndex.active.rawValue)
    }
    
    fileprivate func fillPromoVouchers() {
        fillVouchers()
        segmentedView?.setCounter(text: String(vouchers.count), forButtonAt: SegmentIndex.promo.rawValue)
    }
    
    fileprivate func fillArchiveVouchers() {
        fillVouchers()
    }
    
    private func fillVouchersForSelectedPage() {
        switch selectedPage {
        case .active:
            fillActiveVouchers()
        case .promo:
            fillPromoVouchers()
        case .archive:
            fillArchiveVouchers()
        }
    }
    
    private func updateTableForSelectedPage() {
        fillVouchersForSelectedPage()
        updateTableView()
    }
    
    fileprivate func updateTableView() {
        self.dataSource = TableDataSource(cellIdentifier: VouchersTableViewCell.nibName, items: vouchers, configureCell: { (cell, voucher) in
            cell.model = voucher
        })
        
        tableView?.dataSource = self.dataSource
        tableView?.reloadData()
    }
    
    private func setupSegmentedView() {
        guard let segmentedView = segmentedView else {
            return
        }
        
        let buttonsCount = SegmentIndex.count.rawValue
        segmentedView.buttonsCount = buttonsCount
        for index in 0..<buttonsCount {
            if let enumCase = SegmentIndex(rawValue: index) {
                let title = SegmentIndex.titleFor(enumCase: enumCase)
                segmentedView.setTitle(title, forButtonAt: index)
            }
        }
        
        segmentedView.delegate = self
        segmentedView.hideCounterAt(index: SegmentIndex.archive.rawValue)
    }
    
    private func setupCounters() {
        fillActiveVouchers()
        fillPromoVouchers()
    }
}

extension VouchersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(VoucherViewController(model: vouchers[indexPath.row]), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - MGCSegmentedControlDelegate

extension VouchersViewController: MGCSegmentedControlDelegate {
    func didTapButton(at index: Int) {
        switch index {
        case SegmentIndex.active.rawValue:
            fillActiveVouchers()
        case SegmentIndex.promo.rawValue:
            fillPromoVouchers()
        case SegmentIndex.promo.rawValue:
            fillArchiveVouchers()
        default:
            break
        }
        
        updateTableView()
    }
}
