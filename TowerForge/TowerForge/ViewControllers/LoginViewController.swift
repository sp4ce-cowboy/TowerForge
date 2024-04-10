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
        let authentication = AuthenticationProvider()
        authentication.login(email: email, password: password) { _, err in
            if let error = err {
                self.showAlert(message: error.localizedDescription, title: "Oops")
            } else {
                guard let gameModeViewController =
                        self.storyboard?.instantiateViewController(withIdentifier: "GameModeViewController")
                        as? GameModeViewController else {
                            return
                        }

                self.present(gameModeViewController, animated: true, completion: nil)
            }
        }
    }
    private func showAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let onClose = UIAlertAction(title: "Okay", style: .default) { _ in

        }
        alertController.addAction(onClose)
        present(alertController, animated: true, completion: nil)
    }

}
