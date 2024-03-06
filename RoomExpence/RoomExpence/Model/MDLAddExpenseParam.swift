//
//  MDLAddExpenseParam.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import Foundation

struct MDLExpense: Codable {
    let amount: String
    let desc: String
    let userId: String
    let name: String
    var docId: String? = ""
    var additional: Bool? = false
    let timestamp: Int64
}
