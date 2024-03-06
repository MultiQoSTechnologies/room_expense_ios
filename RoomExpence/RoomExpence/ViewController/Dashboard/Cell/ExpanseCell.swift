//
//  ExpanseCell.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit

class ExpanseCell: UITableViewCell {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewDot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        viewBG.setCorner(radius: 12)
        viewDot.roundView()
    }
    
    func configureCell(item: MDLExpense) { 
        lblDate.text = Date(timeIntervalSince1970: Double(item.timestamp) / 1000).toDate(format: "dd/MM/yyyy")
        lblDesc.text = item.desc
        lblPrice.text = "\(kCurrency) \(item.amount)"
        lblUserName.text = "by: \(item.name)"
    }
}
