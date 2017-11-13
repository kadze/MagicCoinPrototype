//
//  TerminalTableViewCell.swift
//  MagicCoin
//
//  Created by ASH on 8/12/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class TerminalTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var model: Terminal? {
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
    
    func fillWith(model: Terminal) {
        nameLabel.text = model.name
        addressLabel.text = model.address
        distanceLabel.text = String(model.distance)
    }
    
}
