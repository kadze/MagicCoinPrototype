//
//  TransactionTableViewCell.swift
//  MagicCoin
//
//  Created by ASH on 8/1/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowlLabel: UILabel!
    @IBOutlet weak var sumlLabel: UILabel!
    @IBOutlet weak var datelLabel: UILabel!
    @IBOutlet weak var voucherImageView: UIImageView!
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var terminalLabel: UILabel!
    
    var model: Transaction? {
        didSet {
            if let model = model {
                fillWith(model: model)
            }
        }
    }
    
    func fillWith(model: Transaction) {
        let sum: Double = Double(model.sum) / 100
        sumlLabel.text = "\(sum)"
        let sumColor = (model.direction == .income) ? #colorLiteral(red: 0.4235294118, green: 0.6431372549, blue: 0.4039215686, alpha: 1) : #colorLiteral(red: 0.9215686275, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        sumlLabel.textColor = sumColor
        
        let arrow = (model.direction == .income) ? "↑" : "↓"
        arrowlLabel.text = arrow
        arrowlLabel.textColor = sumColor
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        datelLabel.text = formatter.string(from: model.date)
        
        voucherImageView.image = model.voucher.image
        voucherNameLabel.text = model.voucher.title
        terminalLabel.text = model.terminal
    }
    
}
