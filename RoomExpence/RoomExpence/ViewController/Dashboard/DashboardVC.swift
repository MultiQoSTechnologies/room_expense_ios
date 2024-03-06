//
//  DashboardVC.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import UIKit
import Combine

class DashboardVC: UIViewController {
     
//    MARK: - Outlet
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblExpAmount: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var cvUser: CollectionUsers!
    @IBOutlet weak var tblExpense: TableExpense!
    @IBOutlet weak var tblExpenseBottom: NSLayoutConstraint!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblNoData: GenericLabel!
    
    
//    MARK: - Variable
    private var cancellables: Set<AnyCancellable> = []
    var dashboardVM = DashboardViewModel()
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = Constant.user.name
        configureViewModelListener()
        configureCollectionListener()
        configureTableListener() 
        dashboardVM.getAllUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        btnCheckout.setCorner(radius: 8)
        btnCheckout.roundView()
        btnPlus.roundView()
        btnClear.roundView()
        btnCheckout.setBorder(color: .appWhite.withAlphaComponent(0.2), width: 1)
        btnClear.setBorder(color: .appWhite.withAlphaComponent(0.2), width: 1)
        viewHeader.alternateCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 30)
    }
    
}

//    MARK: - Configure ViewModel
extension DashboardVC {
    private func configureViewModelListener() {
        dashboardVM.$alertMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let `self` = self,
                      let message = message else {
                    return
                }
                self.showToast(message: message)
            }
            .store(in: &cancellables)
        
        dashboardVM.$arrUsers
            .receive(on: RunLoop.main)
            .sink { [weak self] arrUsers in
                guard let `self` = self,
                      let arrUsers = arrUsers else {
                    return
                }
                cvUser.arrUsers = arrUsers
                cvUser.arrUsers[0].isSelected = true 
                cvUser.reloadData()
                
                dashboardVM.getAllExpenses()
            }
            .store(in: &cancellables)
        
        dashboardVM.$arrExpenses
            .receive(on: RunLoop.main)
            .sink {  [weak self] arrExpenses in
                guard let `self` = self,
                      let arrExpenses = arrExpenses else {
                    return
                }
                tblExpense.arrExpenses = arrExpenses.filter{$0.additional == false}
                tblExpense.arrFilterdExpenses = tblExpense.arrExpenses
                let arrAmount = arrExpenses.map {$0.amount.toInt}
                lblNoData.isHidden = tblExpense.arrFilterdExpenses.count == 0 ? false : true
                lblExpAmount.text = "\(arrAmount.reduce(0, +))"
                tblExpense.reloadData()
            }
            .store(in: &cancellables)
        
        dashboardVM.$deleteAllExpenseSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] success in
                guard let `self` = self,
                      let success = success else {
                    return
                }
                
                if success {
                    dashboardVM.getAllExpenses()
                }
            }
            .store(in: &cancellables)
    }
}

extension DashboardVC {
    private func configureCollectionListener() {
        cvUser.$didSelectItem
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard let `self` = self,
                      let user = user else {
                    return
                }
                if user.userId == "all" {
                    dashboardVM.getAllExpenses()
                } else {
                    tblExpense.arrFilterdExpenses = tblExpense.arrExpenses
                        .filter{ $0.userId == user.userId }
                }
                
                lblNoData.isHidden = tblExpense.arrFilterdExpenses.count == 0 ? false : true
                
                tblExpense.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    private func configureTableListener() {
        tblExpense.$didSwipeToDelete
            .receive(on: RunLoop.main)
            .sink { [weak self] indexPath in
                guard let `self` = self,
                      let indexPath = indexPath else {
                    return
                }
                let exp = tblExpense.arrFilterdExpenses[indexPath.row]
                if exp.userId == Constant.user.userId {
                    dashboardVM.deleteExpense(id: exp.docId ?? "") { success in
                        if success {
                            self.tblExpense.beginUpdates()
                            self.tblExpense.arrFilterdExpenses.remove(at: indexPath.row)
//                            self.tblExpense.arrExpenses.filter{}
                            self.tblExpense.deleteRows(at: [indexPath], with: .automatic)
                            self.tblExpense.endUpdates()
                        }
                    }
                } else {
                    dashboardVM.alertMessage = "You can not delete other user expenses"
                }
            }
            .store(in: &cancellables)
    }
}

//    MARK: - Events
extension DashboardVC {
    @IBAction private func btnLogoutAction(_ sender: UIButton) {
        self.showAlert(title: "Logout", message: "Are you sure want to logout?", style: .alert, actions: ["Yes", "No"]) { str in
            if str == "Yes" {
                UserDefaults.standard.set(nil, forKey: "User")
                Constant.user = nil
                UIApplication.sceneDelegate?.initLoginView()
            }
        }
    }
    
    @IBAction private func btnPlusAction(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddExpenceVC") as? AddExpenceVC else {
            return
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.callback = { [weak self] success in
            guard let `self` = self else {
                return
            }
            if success {
                dashboardVM.getAllExpenses()
            }
        }
        present(vc, animated: true)
    }
    
    @IBAction private func btnCheckoutAction(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as? CheckoutVC else {
            return
        }
        vc.totalExp = lblExpAmount.text ?? "0"
        vc.dashboardVM = self.dashboardVM
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func btnClearAction(_ sender: UIButton) {
        self.showAlert(title: "Clear all history", message: "Are you sure want to clear history", style: .alert, actions: ["Yes", "No"]) { string in
            if string == "Yes" {
                print("Clear History")
                self.dashboardVM.deleteAllExpenses()
            }
        }
    }

}
