//
//  DashboardViewModel.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import Foundation
import FirebaseFirestore

class DashboardViewModel {
    @Published var arrUsers: [UserModel]?
    @Published var arrExpenses: [MDLExpense]?
    @Published var addExpenseSuccess: Bool?
    @Published var deleteAllExpenseSuccess: Bool?
    @Published var alertMessage: String?
    private let firestore = Firestore.firestore()
}

extension DashboardViewModel {
    func getAllUsers() {
        UIApplication.shared.showLoadingIndicator()
        firestore
            .collection(FICollectionName.users.rawValue)
            .getDocuments { [weak self] qsnapshot, error in
                UIApplication.shared.hideLoadingIndicator()
                guard let `self` = self else {
                    return
                }
                if error == nil {
                    guard let qsnapshot = qsnapshot else { return }
                    arrUsers = qsnapshot.documents.map {$0.data().castToObject()!}
                    let all = UserModel(name: "All", userId: "all")
                    arrUsers?.insert(all, at: 0)
                } else {
                    alertMessage = error?.localizedDescription ?? ""
                }
            }
    }
    
    func validateAddExpense(param: MDLExpense) -> Bool {
        if param.timestamp == 0 {
            alertMessage = "Please select date"
            return false
        } else if param.desc == "" {
            alertMessage = "Please enter description"
            return false
        } else if param.amount == "" {
            alertMessage = "Please enter amount"
            return false
        } else {
            return true
        }
    }
    
    func addExpense(param: MDLExpense) {
        UIApplication.shared.showLoadingIndicator()
        let ref = firestore
            .collection(FICollectionName.expenses.rawValue)
            .document()
        var tmpParam = param
        tmpParam.docId = ref.documentID 
        ref
            .setData(tmpParam.dictionary()) { [weak self] error in
                UIApplication.shared.hideLoadingIndicator()
                guard let `self` = self else {
                    return
                }
                if error == nil {
                    addExpenseSuccess = true
                } else {
                    alertMessage = error?.localizedDescription
                }
            }
    }
    
    func getAllExpenses() {
        UIApplication.shared.showLoadingIndicator()
        firestore
            .collection(FICollectionName.expenses.rawValue)
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] qsnapshot, error in
                UIApplication.shared.hideLoadingIndicator()
                if error == nil {
                    guard let `self` = self,
                          let qsnapshot = qsnapshot else {
                        return
                    }
                    
                    arrExpenses = qsnapshot.documents.map{$0.data().castToObject()!}
                }
            }
    }
    
    func deleteAllExpenses() {
        UIApplication.shared.showLoadingIndicator()
        firestore
            .collection(FICollectionName.expenses.rawValue)
            .getDocuments { [weak self] qsnap, error in
                guard let `self` = self else {
                    return
                }
                if error == nil {
                    guard let qsnap = qsnap else { return }
                    for doc in qsnap.documents {
                        deleteExpense(id: doc.documentID) { _ in }
                    }
                    deleteAllExpenseSuccess = true
                } else {
                    alertMessage = error?.localizedDescription ?? ""
                }
            }
    }
    
    func deleteExpense(id: String, completion: @escaping ((Bool) -> Void)) {
        UIApplication.shared.showLoadingIndicator()
        firestore
            .collection(FICollectionName.expenses.rawValue)
            .document(id)
            .delete { [weak self] error in
                UIApplication.shared.hideLoadingIndicator()
                guard let `self` = self else {
                    return
                }
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                    alertMessage = error?.localizedDescription ?? ""
                }
            }
    }
}
