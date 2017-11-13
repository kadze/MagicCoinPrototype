//
//  GuideChildViewController.swift
//  MagicCoin
//
//  Created by ASH on 7/22/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class GuideChildViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    // MARK: Initializations 
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
