//
//  ViewController.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import UIKit
import Combine

class LoginVC: UIViewController {
    
//    MARK: - Outlet
    @IBOutlet weak private var txtEmail: UITextField!
    @IBOutlet weak private var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: GradientButton!
    
//    MARK: - Variable
    private var loginVM = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModelListener()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    func setupUI() {
        btnLogin.roundView()
    }
}

//  MARK: - Configure ViewModel
extension LoginVC {
    private func configureViewModelListener() {
        loginVM.$alertMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let `self` = self,
                      let message = message else {
                    return
                }
                self.showToast(message: message)
            }
            .store(in: &cancellables)
        
        loginVM.$loginSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] success in
                guard let `self` = self,
                      let success = success else {
                    return
                }
                
                if success {
                    UIApplication.sceneDelegate?.initDashboardView()
                }
            }
            .store(in: &cancellables)
    }
}

//  MARK: - Eventes
extension LoginVC {
    @IBAction private func btnLoginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let params = MDLLoginParam(email: txtEmail.text ?? "", password: txtPassword.text ?? "")
        if loginVM.validateLoginForm(params: params) {
            loginVM.performLogin(params: params)
        }
    }
    
    @IBAction private func btnSignupAction(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
