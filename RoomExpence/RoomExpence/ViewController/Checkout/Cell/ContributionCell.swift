//
//  ContributionCell.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit

class ContributionCell: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblContributor: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDistribution: UILabel!
    @IBOutlet weak var lblRemaining: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        viewBG.setCorner(radius: 12)
    }
    
    func configureCell(contributor: String, amount: Int, distribution: Int, remaining: Int) {
        lblContributor.text = contributor
        lblAmount.text = "\(kCurrency) \(amount)"
        lblDistribution.text = "\(kCurrency) \(distribution)"
        lblRemaining.text = "\(kCurrency) \(remaining)"
        
        lblRemaining.textColor = remaining < 0 ? .red : .green1
        
    }
}
