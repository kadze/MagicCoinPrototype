//
//  Transaction.swift
//  MagicCoin
//
//  Created by ASH on 8/1/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation

struct Transaction {
    enum TransactionDirection {
        case income
        case outcome
    }
    
    let direction: TransactionDirection
    let voucher: Voucher
    let sum: Int
    let date: Date
    let terminal: String
}
