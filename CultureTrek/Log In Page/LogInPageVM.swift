//
//  LogInPageVM.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/8/24.
//

import Foundation
import Combine


class LogInViewModel: ObservableObject {
    
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var navigateToExpensesPage = false
    
    weak var delegate: LogInPageViewDelegate?
    
    func validateInputs() {
        if username.isEmpty {
            alertMessage = "Please enter an email address."
            showAlert = true
            return
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: username) {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }
        
        if password.isEmpty {
            alertMessage = "Please enter a password."
            showAlert = true
            return
        } else {
            delegate?.navigateToMainPage()
        }
    }
}
