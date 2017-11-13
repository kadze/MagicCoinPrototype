//
//  MGCTextField.swift
//  MagicCoin
//
//  Created by Oleh Korchytskyi on 02/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

@IBDesignable class MGCTextField: DesignableTextField {
    @IBInspectable var fillUpTo: Int = 1
    
    @IBInspectable var secureOnResign: Bool = false

    @IBOutlet weak var prevField: MGCTextField?
    @IBOutlet weak var nextField: MGCTextField?
    
    var prevText: String?
    
    var isDeleting = false
    override var canBecomeFirstResponder: Bool {
        if isDeleting {
            isDeleting = false
            return super.canBecomeFirstResponder
        }
        
        let isFilled = (text?.lengthOfBytes(using: .utf8) ?? 0) > 0
        if let _ = nextField, isFilled {
            return false
        }
        
        if let prevField = prevField,
            !isFilled,
            ((prevField.text?.lengthOfBytes(using: .utf8) ?? 0) == 0)
        {
            return false
        }
        
        return super.canBecomeFirstResponder
    }
    
    override var text: String? {
        didSet {
            prevText = oldValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    weak var focusedBackgroundView: UIView?
    var focusedBackgroundViewHeightConstraint: NSLayoutConstraint?
    
    weak var bottomLineView: UIView?
    
    func setup() {
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: nil, queue: .main) { [weak self] (notification) in
            
            if let field = notification.object as? MGCTextField, field == self {
                self?.didChange(text: field.text)
            }
        }
        
        let focusedBackgroundView = UIView()
        focusedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(focusedBackgroundView)
        
        let focusedBackgroundViewOptionalHeightConstraint = focusedBackgroundView.heightAnchor.constraint(equalToConstant: 0)
        focusedBackgroundViewOptionalHeightConstraint.priority = UILayoutPriorityDefaultLow
        focusedBackgroundViewOptionalHeightConstraint.isActive = true
        focusedBackgroundViewHeightConstraint = focusedBackgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1, constant: 0)
        focusedBackgroundViewHeightConstraint?.isActive = false
        focusedBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        focusedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        focusedBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        focusedBackgroundView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.6352941176, blue: 0.8549019608, alpha: 0.2)
        focusedBackgroundView.alpha = 1
        
        self.focusedBackgroundView = focusedBackgroundView
        
        let bottomLineView = UIView()
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLineView)
        bottomLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        bottomLineView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9098039216, blue: 0.9764705882, alpha: 0.2)
        
        self.bottomLineView = bottomLineView
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            didBecame(focused: true)
        } else {
            activateFirstEmptyField()
        }
        
        return result
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        didBecame(focused: false)
        return result
    }
    
    func didBecame(focused: Bool) {
        
        if focused {
            setCursorPosition(input: self, position: (text?.lengthOfBytes(using: .utf8) ?? 1))
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [weak self] in
            if self?.secureOnResign ?? false {
                self?.isSecureTextEntry = !focused
            }
        }
        
        animator.startAnimation()
    }
    
    func isFilledInGroup() -> Bool {
        
        var field = self
        
        while let prevField = field.prevField {
            if (prevField.text?.lengthOfBytes(using: .utf8) ?? 0) > 0 {
                return true
            } else {
                field = prevField
            }
        }
        
        field = self
        
        while let nextField = field.nextField {
            if (nextField.text?.lengthOfBytes(using: .utf8) ?? 0) > 0 {
                return true
            } else {
                field = nextField
            }
        }
        
        return (self.text?.lengthOfBytes(using: .utf8) ?? 0) > 0
    }
    
    func isFocusedInGroup() -> Bool {
        
        var field = self
        
        while let prevField = field.prevField {
            if prevField.isFirstResponder {
                return true
            } else {
                field = prevField
            }
        }
        
        field = self
        
        while let nextField = field.nextField {
            if nextField.isFirstResponder {
                return true
            } else {
                field = nextField
            }
        }
        
        return self.isFirstResponder
    }
    
    func didChange(text: String?) {
        let filled = text?.lengthOfBytes(using: .utf8) ?? 0
        
        if filled >= fillUpTo {
            resignFirstResponder()
            
            if filled > fillUpTo, let text = text {
                self.text = text.substring(from: text.index(text.startIndex, offsetBy: fillUpTo))
            }
            
            isSecureTextEntry = true
            
            if let nextField = nextField {
                nextField.becomeFirstResponder()
            }
            
        } else {
            prevField?.becomeFirstResponder()
        }
    }
    
    // MARK: - Helpers
    private func setCursorPosition(input: UITextField, position: Int) {
        
        let position = position < 0 ? 0 : position
        
        let positionInText = input.position(from: input.beginningOfDocument, offset: position)
        input.selectedTextRange = input.textRange(from: positionInText ?? .init(), to: positionInText ?? .init())
    }
    
    func activateFirstEmptyField() {
        let isFilled = (text?.lengthOfBytes(using: .utf8) ?? 0) > 0
        var activeField = self
        if !isFilled {
            while let prevField = activeField.prevField {
                activeField = prevField
                if (prevField.text?.isEmpty ?? true &&
                    (!(prevField.prevField?.text?.isEmpty ?? true) || prevField.prevField == nil))
                {
                    prevField.becomeFirstResponder()
                    return
                }
            }
        } else {
            while let nextField = activeField.nextField {
                activeField = nextField
                if nextField.text?.isEmpty ?? true {
                    nextField.becomeFirstResponder()
                    return
                }
            }
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        if text?.isEmpty ?? true {
            prevField?.isDeleting = true
            prevField?.becomeFirstResponder()
        }
    }
}









