//
//  VocherViewController.swift
//  MagicCoin
//
//  Created by ASH on 8/3/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class VoucherViewController: UIViewController {

    var model: Voucher? {
        didSet {
            self.fillWithModel()
        }
    }
    
    //MARK: Initializations and Deallocations
    
    init(model: Voucher){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillWithModel()
    }
    
    //MARK: Private
    
    private func fillWithModel() {
        if let view = view as? VoucherView {
            view.model = model
        }
        
        title = model?.title
    }
    
    
}
