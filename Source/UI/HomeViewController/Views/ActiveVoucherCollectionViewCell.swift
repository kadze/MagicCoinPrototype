//
//  ActiveVoucherCollectionViewCell.swift
//  MagicCoin
//
//  Created by ASH on 7/31/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class ActiveVoucherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    var model: Voucher? {
        didSet {
            if let model = model {
                self.fillWith(model: model)
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureBordersAndShadows()
    }
    
    //MARK: - Public
    
    func fillWith(model: Voucher) {
        imageView.image = model.image
        titleLabel.text = model.title
        sumLabel.text = "\(model.balance) BTH"
    }
    
    //MARK: - Private
    
    private func configureBordersAndShadows() {
        cornerRadius = 10
        borderWidth = 1
        borderColor = #colorLiteral(red: 0.7450980392, green: 0.6156862745, blue: 0.4274509804, alpha: 1)
        
        shadowRadius = 5
        shadowOffset = CGSize(width: 0, height: 5.0)
        shadowColor = #colorLiteral(red: 0.7450980392, green: 0.6156862745, blue: 0.4274509804, alpha: 1)
        shadowOpacity = 0.5
        layer.masksToBounds = false
    }

}
