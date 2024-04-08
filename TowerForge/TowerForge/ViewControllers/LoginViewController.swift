//
//  LoginViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 08/04/24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private var emailInputField: UITextField!
    @IBOutlet private var passwordInputField: UITextField!
    private var isLogInSuccessful = false
    @IBAction private func onLoginPressed(_ sender: Any) {
        guard let email = emailInputField.text,
              let password = passwordInputField.text else {
            return
        }
        self.login(email: email, password: password)
    }
    @IBAction private func onRegisterPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToRegister", sender: self)
    }
    private func login(email: String, password: String) {
        let delegate = self
        let authentication = AuthenticationProvider()
        authentication.login(email: email, password: password) { _, err in
            if let error = err {
                print(error)
            } else {
                self.isLogInSuccessful = true
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueToMenuGame" {
            return isLogInSuccessful
        }
        return true
    }
}
