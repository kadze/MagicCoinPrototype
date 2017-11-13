//
//  MGCSegmentedControl.swift
//  MagicCoin
//
//  Created by ASH on 8/12/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

protocol MGCSegmentedControlDelegate : AnyObject {
    func didTapButton(at index: Int)
}

class MGCSegmentedControl: UIView {

    let counterLabelWidth: CGFloat = 20
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!

    var countersVisible = true
    var buttonsCount: Int = 0 {
        didSet {
            buttons.removeAll()
            counters.removeAll()
            while let subview = stackView.arrangedSubviews.last {
                stackView.removeArrangedSubview(subview)
            }
            
            for _ in 0..<buttonsCount {
                addButton(UIButton(type: .custom), withCounter: countersVisible)
            }
        }
    }
    
    weak var delegate: MGCSegmentedControlDelegate?
    
    private var buttons = [UIButton]()
    private var counters = [UILabel]()
    
    //MARK: - Initializations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
    }
    
    //MARK: - Actions
    
    @objc private func onButton(_ sender: UIButton) {
        select(button: sender)
    }
    
    //MARK: - Public
    
    func setTitle(_ title: String, forButtonAt index: Int) {
        if index >= buttons.count {
            return
        }
        
        buttons[index].setTitle(title, for: .normal)
        buttons[index].setTitle(title, for: .selected)
    }
    
    func setCounter(text: String, forButtonAt index: Int) {
        if index >= counters.count {
            return
        }
        
        counters[index].text = text
    }
    
    func selectButtonAt(index: Int) {
        select(button: buttons[index])
    }
    
    func hideCounterAt(index: Int) {
        if counters.count >= index, index >= 0 {
            counters[index].isHidden = true
        }
    }
    
    func showCounterAt(index: Int) {
        if counters.count >= index, index >= 0 {
            counters[index].isHidden = true
        }
    }
    
    //MARK: - Private
    
    private func configure(button: UIButton) {
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func select(button: UIButton) {
        if let buttonIndex = buttons.index(of: button) {
            delegate?.didTapButton(at: buttonIndex)
            buttons.forEach{$0.isSelected = false}
            button.isSelected = true
        }
    }
    
    //needs to add button of "custom" type to be beautifull (without dark rect when tap)
    private func addButton(_ button: UIButton, withCounter: Bool = false) {
        if buttons.count == 0 {
            button.isSelected = true
        }
        
        buttons.append(button)
        button.addTarget(self, action: #selector(onButton(_:)), for: .touchUpInside)
        button.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 1), for: .normal)
        button.tintColor = #colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 1)
        button.setBackgroundImage(UIImage(color: #colorLiteral(red: 0.937254902, green: 0.7843137255, blue: 0.5490196078, alpha: 1)), for: .selected)
        button.setBackgroundImage(UIImage(color: #colorLiteral(red: 0.937254902, green: 0.7843137255, blue: 0.5490196078, alpha: 0.5)), for: .highlighted)
        button.layer.masksToBounds = true
        
        if withCounter {
            addCounterTo(button: button)
        }
        
        stackView.addArrangedSubview(button)
    }
    
    private func removeButtonAt(index: Int) {
        buttons.remove(at: index)
        counters.remove(at: index)
    }
    
    private func addCounterTo(button: UIButton) {
        let counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: counterLabelWidth, height: counterLabelWidth))
        counters.append(counterLabel)
        counterLabel.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.3803921569, blue: 0.5725490196, alpha: 1)
        counterLabel.layer.cornerRadius = counterLabelWidth / 2
        counterLabel.layer.masksToBounds = true
        counterLabel.textAlignment = .center
        counterLabel.textColor = .white
        counterLabel.font = UIFont.boldSystemFont(ofSize: 10)
        button.addSubview(counterLabel)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [counterLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
             counterLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
             counterLabel.heightAnchor.constraint(equalToConstant: counterLabelWidth),
             counterLabel.widthAnchor.constraint(equalToConstant: counterLabelWidth)]
        )
    }
}
