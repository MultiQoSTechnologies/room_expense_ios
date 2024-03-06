//
//  TableContribution.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit

class TableContribution: UITableView {
    
    var dictUserExpense: Dictionary<String, [MDLExpense]> = [:]
    var totalExp = 0
    var arrUser = [UserModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
}

extension TableContribution: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContributionCell") as? ContributionCell else { return UITableViewCell() }
        let user = arrUser[indexPath.row]
        let totalContribution = dictUserExpense.filter{$0.key == user.userId }.first?.value.map{$0.amount.toInt ?? 0}.reduce(0, +) ?? 0
        let totalDistributionAmount = totalExp/arrUser.count
        
        let remainingPaymentAmount = totalContribution - totalDistributionAmount
        cell.configureCell(contributor: user.name ?? "", amount: totalContribution, distribution: totalDistributionAmount, remaining: remainingPaymentAmount)
        return cell
    }
}
