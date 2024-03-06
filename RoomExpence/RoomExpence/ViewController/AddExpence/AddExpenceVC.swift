//
//  AddExpenceVC.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit
import Combine
import IQKeyboardManagerSwift

class AddExpenceVC: UIViewController {

//    MARK: - Outlet
    @IBOutlet weak var btnCancel: GenericButton!
    @IBOutlet weak var txtDate: GenericTextfield!
    @IBOutlet weak var txtDesc: GenericTextfield!
    @IBOutlet weak var txtAmount: GenericTextfield!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
//    MARK: - Variable
    private var cancellables: Set<AnyCancellable> = []
    private let dashboardVM = DashboardViewModel()
    private let datePicker = UIDatePicker()
    
    var isFromCheckout: Bool = false
    var callback: ((Bool) -> Void)?
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
        configureViewModelListener()
        lblTitle.text = isFromCheckout ? "Add additional expense" : "Add your expense"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        viewBG.setCorner(radius: 20)
        btnCancel.setBorder(color: .green1, width: 2)
    }
    
    func configureDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        txtDate.delegate = self
        txtDate.inputView = datePicker
    }

}

//    MARK: - Configure ViewModel
extension AddExpenceVC {
    func configureViewModelListener() {
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
        
        dashboardVM.$addExpenseSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] success in
                guard let `self` = self,
                      let success = success else {
                    return
                }
                if success {
                    callback?(success)
                    dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

//    MARK: - Events
extension AddExpenceVC {
    @objc func dateDidChange() {
        txtDate.text = datePicker.date.toDate(format: "dd/MM/yyyy")
    }
    @IBAction private func btnAddAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let param = MDLExpense(
            amount: txtAmount.text ?? "",
            desc: txtDesc.text ?? "",
            userId: Constant.user.userId,
            name: Constant.user.name ?? "",
            additional: isFromCheckout,
            timestamp: datePicker.date.currentTimeMillis())
         
        if dashboardVM.validateAddExpense(param: param) {
            dashboardVM.addExpense(param: param)
        }
    }
    
    @IBAction private func btnCancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension AddExpenceVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDate {
            dateDidChange()
        }
    }
}
