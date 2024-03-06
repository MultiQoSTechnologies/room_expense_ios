//
//  TableExpense.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit
import Combine

class TableExpense: UITableView {

    var arrExpenses = [MDLExpense]()
    var arrFilterdExpenses = [MDLExpense]()
    
    @Published var didSwipeToDelete: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        self.showsVerticalScrollIndicator = false
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        if arrExpenses.count > 5 {
            self.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 100, right: 0)
        } else {
            self.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }
    }
}

extension TableExpense: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterdExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpanseCell") as? ExpanseCell else { return UITableViewCell() }
        let item = arrFilterdExpenses[indexPath.row]
        cell.configureCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           didSwipeToDelete = indexPath
        }
    }
}
