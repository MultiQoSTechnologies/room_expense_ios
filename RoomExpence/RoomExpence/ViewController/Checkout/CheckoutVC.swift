//
//  CheckoutVC.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit
import Combine
import Floaty

class CheckoutVC: UIViewController {
    
    //    MARK: - Outlet 
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblExpAmount: GenericLabel!
    @IBOutlet weak var tblUserContribution: TableContribution!
    @IBOutlet weak var txtAdditionalExp: GenericTextfield!
    @IBOutlet weak var viewAdditionalExp: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblCheckout: GenericLabel!
    @IBOutlet weak var lblTotalExAddtional: GenericLabel!
    @IBOutlet weak var lblGrandTotal: GenericLabel!
    
    @IBOutlet weak var lblAdditionalExp: UILabel!
    
    var totalExp = ""
    private var cancellables: Set<AnyCancellable> = []
    
    let floaty = Floaty()
      
    //    MARK: - Variable
    private var cancellable = Set<AnyCancellable>()
    var dashboardVM = DashboardViewModel()
    
    //    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViewModelListener()
        configureFloaty()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        viewHeader.alternateCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 30)
    }
    
    func configureTableView() {
        let arrExpense = dashboardVM.arrExpenses ?? []
        lblExpAmount.text = totalExp
        lblGrandTotal.text = "\(kCurrency) \(totalExp)"
        lblAdditionalExp.text = "\(kCurrency) \(arrExpense.filter{$0.additional == true}.map{$0.amount.toInt}.reduce(0, +))"
        lblTotalExAddtional.text = "\(kCurrency) \(arrExpense.filter{$0.additional == false}.map{$0.amount.toInt}.reduce(0, +))"
        
        tblUserContribution.dictUserExpense = Dictionary(grouping: dashboardVM.arrExpenses ?? [], by: {$0.userId})
        
        tblUserContribution.arrUser = dashboardVM.arrUsers?.filter{$0.userId != "all"} ?? []
        
        tblUserContribution.reloadData()
        tblUserContribution.totalExp = totalExp.toInt 
    }
    
    func configureFloaty() {
        floaty.buttonColor = .green2
        floaty.paddingY = 40
        floaty.paddingX = 20
        floaty.hasShadow = false
        floaty.size = 60
        floaty.buttonImage = UIImage(systemName: "plus")?.tint(with: .appWhite)
        floaty.itemTitleColor = .appWhite
        floaty.itemShadowColor = .clear
        floaty.addItem("Add additional expense", icon: UIImage(systemName: "doc.plaintext")) { [weak self] item in
            guard let `self` = self else {
                return
            }
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddExpenceVC") as? AddExpenceVC else {
                return
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.isFromCheckout = true
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
        
        floaty.addItem("Share", icon: UIImage(systemName: "square.and.arrow.up")) { [weak self] item in
            guard let `self` = self else {
                return
            }
            btnBack.isHidden = true
            lblCheckout.isHidden = true
            floaty.isHidden = true
            guard let image = self.view.image() else { return }
            let imageShare = [image]
            let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true) { [weak self] in
                guard let `self` = self else {
                    return
                }
                btnBack.isHidden = false
                lblCheckout.isHidden = false
                floaty.isHidden = false
            }
        }
        self.view.addSubview(floaty)
    }
}

extension CheckoutVC {
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
        
        dashboardVM.$arrExpenses
            .receive(on: RunLoop.main)
            .sink { [weak self] arrExpenses in
                guard let `self` = self,
                      let arrExpenses = arrExpenses else {
                    return
                }
                lblExpAmount.text = arrExpenses.map{$0.amount.toInt}.reduce(0, +).toString
                
                lblGrandTotal.text = "\(kCurrency) \(lblExpAmount.text ?? "0")"
                lblAdditionalExp.text = "\(kCurrency) \(arrExpenses.filter{$0.additional == true}.map{$0.amount.toInt}.reduce(0, +))"
                lblTotalExAddtional.text = "\(kCurrency) \(arrExpenses.filter{$0.additional == false}.map{$0.amount.toInt}.reduce(0, +))"
                
                tblUserContribution.dictUserExpense = Dictionary(grouping: arrExpenses, by: {$0.userId})
                tblUserContribution.reloadData()
                tblUserContribution.totalExp = lblExpAmount.text?.toInt ?? 0
            }
            .store(in: &cancellable)
    }
}

//      MARK: - Event
extension CheckoutVC {
    @IBAction private func btnAddAction(_ sender: UIButton) {
        let talExp = "\((txtAdditionalExp.text?.toInt ?? 0) + (self.totalExp.toInt))"
        lblExpAmount.text = talExp
        tblUserContribution.totalExp = talExp.toInt 
        tblUserContribution.reloadData()
    }
}
