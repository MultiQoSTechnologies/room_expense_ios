//
//  RegisterVC.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import UIKit
import Combine

class RegisterVC: UIViewController {

//    MARK: - Outlet
    @IBOutlet weak private var imgProfile: UIImageView!
    @IBOutlet weak private var txtName: UITextField!
    @IBOutlet weak private var txtPassword: UITextField!
    @IBOutlet weak private var txtEmai: UITextField!
    @IBOutlet weak var btnRegister: GradientButton!
    
//    MARK: - Variable
    private var registerVM: RegisterViewModel = RegisterViewModel()
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
        imgProfile.roundView()
        btnRegister.roundView()
    }
}

//    MARK: - Configure ViewModel
extension RegisterVC {
    func configureViewModelListener() {
        registerVM.$alertMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let `self` = self,
                      let message = message else {
                    return
                }
                self.showToast(message: message)
            }
            .store(in: &cancellables)
        
        registerVM.$registerSuccess
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
extension RegisterVC {
    
    @IBAction private func btnProfileAction(_ sender: UIButton) {
        self.view.endEditing(true)
        showAlert(title: "Select image", message: "Please choose image to set profile picture", style: .actionSheet, actions: ["Photos", "Camera", "Cancel"]) { string in
            ImagePicker.shared.allowEditing = true
            if string == "Photos" {
                ImagePicker.shared.openGallery()
            } else if string == "Camera" {
                ImagePicker.shared.openCamera()
            }
            ImagePicker.shared.imageCompletion = { [weak self] image in
                guard let `self` = self else {
                    return
                }
                imgProfile.image = image
            }
        }
    }
    
    @IBAction private func btnRegisterAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let params = MDLRegisterParam(name: txtName.text ?? "",
                                      email: txtEmai.text ?? "",
                                      password: txtPassword.text ?? "",
                                      image: imgProfile.image, image_url: "")
        
        if registerVM.validateRegisterForm(params: params) {
            registerVM.createNewUserInAuth(with: params)
        }
    }
}
