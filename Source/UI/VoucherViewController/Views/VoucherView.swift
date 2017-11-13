//
//  VoucherView.swift
//  MagicCoin
//
//  Created by ASH on 8/3/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class VoucherView: UIView {
    
    @IBOutlet weak var voucherImageView: UIImageView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var validDateLabel: UILabel!
    
    var model: Voucher? {
        didSet {
            self.fillWithModel()
        }
    }
    
    //MARK: Private
    
    private func fillWithModel() {
        guard  let model = model else {
            return
        }
        
        activeLabel.text = model.active ? "ACTIVE" : ""
        
        voucherImageView.image = model.image
        balanceLabel.text = "\(model.balance) BHT"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        validDateLabel.text = "Valid until \(formatter.string(from: model.validDate))"
        
    }
}
