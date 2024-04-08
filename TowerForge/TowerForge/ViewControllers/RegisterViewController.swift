//
//  RegisterViewController.swift
//  TowerForge
//
//  Created by MacBook Pro on 08/04/24.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    private var authenticationProvider: AuthenticationProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationProvider = AuthenticationProvider()
    }

    @IBAction func onRegisterPressed(_ sender: Any) {
        guard let email = emailInput.text,
              let username = usernameInput.text,
              let password = passwordInput.text else {
            return
        }
        
        authenticationProvider?.register(email: email, username: username, password: password) { _, err in
            if let error = err {
                print(error)
            } else {
                self.performSegue(withIdentifier: "segueToMenuGame", sender: self)
            }
        }
    }
}

