//
//  LoginViewModel.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel {
    @Published var alertMessage: String?
    @Published var loginSuccess: Bool?
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
}

extension LoginViewModel {
    func validateLoginForm(params: MDLLoginParam) -> Bool {
         if params.email.isEmpty || params.email == "" {
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
    
    func performLogin(params: MDLLoginParam) {
        UIApplication.shared.showLoadingIndicator()
        
        auth.signIn(withEmail: params.email, password: params.password) { [weak self] result, error in
            guard let `self` = self else {
                return
            }
            if error == nil {
                firestore
                    .collection(FICollectionName.users.rawValue)
                    .whereField("email", isEqualTo: params.email)
                    .getDocuments { [weak self] snapshot, error in
                        UIApplication.shared.hideLoadingIndicator()
                        guard let `self` = self,
                              let snapshot = snapshot else {
                            return
                        }
                        
                        let model: UserModel? = snapshot.documents.first?.data().castToObject()
                        do {
                            try UserDefaults.standard.set<UserModel>(object: model.self, forKey: "User")
                            Constant.user = model
                            loginSuccess = true
                        } catch (let e) {
                            alertMessage = e.localizedDescription
                        }
                    }
            } else {
                UIApplication.shared.hideLoadingIndicator()
                alertMessage = error?.localizedDescription ?? ""
            }
        }
    }
}
