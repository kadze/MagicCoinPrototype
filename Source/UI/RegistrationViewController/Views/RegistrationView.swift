//
//  RegistrationView.swift
//  MagicCoin
//
//  Created by ASH on 7/26/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

class RegistrationView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var verticalConstraint1: NSLayoutConstraint!
    @IBOutlet weak var verticalConstraint2: NSLayoutConstraint!
    
    let iPhone5sStackViewSpacing: CGFloat = 0
    let iPhone5sverticalConstraintConstant: CGFloat = 4
    
    //MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeForKeyboardNotifications()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        if UIScreen.main.isiPhone5 {
            stackView.spacing = iPhone5sStackViewSpacing
            verticalConstraint1.constant = iPhone5sverticalConstraintConstant
            verticalConstraint2.constant = iPhone5sverticalConstraintConstant
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    //MARK: Keyboard handling
    
    func subscribeForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: .UIKeyboardDidChangeFrame, object: nil)
    }
    
    @objc func keyboardFrameChanged(_ notification: Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let convertedFrame = convert(frame, from: UIScreen.main.coordinateSpace)
        let intersectedKeyboardHeight = frame.intersection(convertedFrame).height
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [weak self] in
            self?.scrollView.contentInset.bottom = self?.scrollView.contentInset.bottom == 0 ? intersectedKeyboardHeight : 0
        }
        
        animator.startAnimation()
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}
