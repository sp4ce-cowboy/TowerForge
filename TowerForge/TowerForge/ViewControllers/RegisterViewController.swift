//
//  RegisterViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 08/04/24.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet private var emailInput: UITextField!
    @IBOutlet private var usernameInput: UITextField!
    @IBOutlet private var passwordInput: UITextField!
    private var authenticationProvider: AuthenticationProvider?
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationProvider = AuthenticationProvider()
    }

    @IBAction private func onRegisterPressed(_ sender: Any) {
        guard let email = emailInput.text,
              let username = usernameInput.text,
              let password = passwordInput.text else {
            return
        }

        authenticationProvider?.register(email: email, username: username, password: password) { _, err in
            if let error = err {
                self.showAlert(message: error.localizedDescription, title: "Oops")
                return
            }
            if let navigationController = self.navigationController,
               let gameModeVC = navigationController.viewControllers.first(where: { $0 is GameModeViewController }) {
                self.navigationController?.popToViewController(gameModeVC, animated: true)
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
