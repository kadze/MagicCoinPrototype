//
//  VouchersTableViewCell.swift
//  MagicCoin
//
//  Created by ASH on 8/2/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class VouchersTableViewCell: UITableViewCell {

    @IBOutlet weak var voucherImageView: UIImageView!
    @IBOutlet weak var actuveLabel: UILabel!
    @IBOutlet weak var voucherLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var validDateLabel: UILabel!
    
    var model: Voucher? {
        didSet {
            if let model = model {
                fillWith(model: model)
            }
        }
    }
    
    //MARK: Public
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.6156862745, blue: 0.4274509804, alpha: 0.3)
    }
    
    func fillWith(model: Voucher) {
        voucherImageView.image = model.image
        voucherLabel.text = model.title
        balanceLabel.text = "\(model.balance) BHT"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        validDateLabel.text = "Valid until \(formatter.string(from: model.validDate))"
    }
    
}
