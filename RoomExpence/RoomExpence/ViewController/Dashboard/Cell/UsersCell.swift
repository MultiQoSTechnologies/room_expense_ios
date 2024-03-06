//
//  UsersCell.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit

class UsersCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        viewBG.roundView()
    }
    
    func configureCell(user: UserModel) {
        if user.isSelected ?? false {
            lblTitle.textColor = .green2
            viewBG.setBorder(color: .green2, width: 2)
        } else {
            lblTitle.textColor = .appGray
            viewBG.setBorder(color: .appGray.withAlphaComponent(0.4), width: 2)
        }
        lblTitle.text = user.name
    }
}
