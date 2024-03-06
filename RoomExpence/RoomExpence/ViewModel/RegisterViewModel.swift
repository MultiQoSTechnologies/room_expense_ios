//
//  RegisterViewModel.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegisterViewModel {
    @Published var alertMessage: String?
    @Published var registerSuccess: Bool?
    private let auth = Auth.auth()
    private let storage = Storage.storage().reference()
    private let firestore = Firestore.firestore()
}


extension RegisterViewModel {
    func validateRegisterForm(params: MDLRegisterParam) -> Bool {
        if params.name.isEmpty || params.name == "" {
            alertMessage = "Please enter your name"
            return false
        } else if params.email.isEmpty || params.email == "" {
            alertMessage = "Please enter email"
            return false
        } else if !params.email.isValidEmail() {
            alertMessage = "Please enter valid email"
            return false
        } else if params.password.isEmpty || params.password == "" {
            alertMessage = "Please enter password"
            return false
        } else if params.password.count < 6 {
            alertMessage = "Please enter password more than 6 character"
            return false
        } else {
            return true
        }
    }
    
    func createNewUserInAuth(with params: MDLRegisterParam) {
        UIApplication.shared.showLoadingIndicator()
        if params.image == nil {
            createAccount(params: params)
        } else {
            guard let imageData = params.image!.jpegData(compressionQuality: 0.5) else {
                createAccount(params: params)
                return
            }
            let ref = storage
                .child("/profile/user_\(Date().currentTimeMillis())")
            ref
                .putData(imageData) { result in
                    switch result {
                    case .success(_):
                        ref.downloadURL { [weak self] url, error in
                            guard let `self` = self else {
                                UIApplication.shared.hideLoadingIndicator()
                                return
                            }
                            guard let url = url else {
                                UIApplication.shared.hideLoadingIndicator()
                                print("Erorr in download url: \(error?.localizedDescription ?? "")")
                                return
                            }
                            var newParam = params
                            newParam.image_url = url.absoluteString
                            createAccount(params: newParam)
                        }
                        
                    case .failure(let failure):
                        UIApplication.shared.hideLoadingIndicator()
                        print("Error in upoad image: \(failure.localizedDescription)")
                    }
                }
        }
        
    }
    
    private func createAccount(params: MDLRegisterParam) {
        auth.createUser(withEmail: params.email, password: params.password) { [weak self] result, error in
            guard let `self` = self else {
                return
            }
            UIApplication.shared.hideLoadingIndicator()
            if error == nil {
                if let result = result {
                    setUserData(result: result, params: params)
                    registerSuccess = true
                }
            } else {
                if let error = error as NSError? {
                    let authError = AuthErrorCode(_nsError: error).code
                    switch authError {
                    case .invalidEmail:
                        alertMessage = "Invalid email address"
                    case .emailAlreadyInUse:
                        alertMessage = "Email already in use"
                    default:
                        alertMessage = "Opps... something went wrong"
                        AppPrint.print("Other error!")
                    }
                }
            }
        }
    }
    
//    Set data to firestore and save to local
    private func setUserData(result: AuthDataResult, params: MDLRegisterParam) {
        let user = result.user
        let model = UserModel(email: user.email ?? "", name: params.name, userId: user.uid, profile_pic: params.image_url)
        do {
            try UserDefaults.standard.set<UserModel>(object: model.self, forKey: "User")
            firestore
                .collection(FICollectionName.users.rawValue)
                .document(user.uid)
                .setData(model.dictionary())
            Constant.user = model
        } catch let error {
            AppPrint.print("Store error : \(error.localizedDescription)")
        }
    }
}
