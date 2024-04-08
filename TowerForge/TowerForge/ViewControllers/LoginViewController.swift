//
//  LoginViewController.swift
//  TowerForge
//
//  Created by MacBook Pro on 08/04/24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    
    @IBAction func onLoginPressed(_ sender: Any) {
        guard let email = emailInputField.text,
              let password = passwordInputField.text else {
            return
        }
        self.login(email: email, password: password)
    }
    @IBAction func onRegisterPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToRegister", sender: self)
    }
    private func login(email: String, password: String) {
        let delegate = self
        let authentication = AuthenticationProvider()
        authentication.login(email: email, password: password) { _, err in
            if let error = err {
                print(error)
            } else {
                self.performSegue(withIdentifier: "segueToMenuGame", sender: self)
            }
        }
    }
}

