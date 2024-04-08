//
//  AuthenticationProvider.swift
//  TowerForge
//
//  Created by Vanessa Mae on 08/04/24.
//

import Foundation

class AuthenticationProvider {
    private let authenticationManager: AuthenticationManager
    private var observers = [AuthenticationDelegate]()
    var isLoggedIn = false

    init(authenticationManager: AuthenticationManager = AuthenticationManager()) {
        self.authenticationManager = authenticationManager
        self.authenticationManager.setListener(delegate: self)
    }
    func login(email: String, password: String, completion: @escaping (AuthenticationData?, Error?) -> Void) {
        self.authenticationManager.loginUser(email: email,
                                             password: password,
                                             completion: completion)
        print("In provider: login")
    }
    func register(email: String,
                  username: String,
                  password: String,
                  completion: @escaping (AuthenticationData?, Error?) -> Void) {
        self.authenticationManager.registerUser(email: email,
                                                username: username,
                                                password: password,
                                                onFinish: completion)
    }
    func getUserDetails(completion: @escaping (AuthenticationData?, Error?) -> Void) {
        self.authenticationManager.getUserData(completion: completion)
    }
    func logout(completion: @escaping (Error?) -> Void) {
        self.authenticationManager.logoutUser(completion: completion)
    }
    func addObserver(_ observer: AuthenticationDelegate) {
        observers.append(observer)
    }
    func removeObserver(_ observer: AuthenticationDelegate) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    private func notifyObserversLogin() {
        observers.forEach { $0.onLogin() }
    }
    private func notifyObserversLogout() {
        observers.forEach { $0.onLogout() }
    }
}

extension AuthenticationProvider: AuthenticationDelegate {
    func onLogout() {
        isLoggedIn = false
        self.notifyObserversLogout()
    }

    func onLogin() {
        isLoggedIn = true
        self.notifyObserversLogin()
    }

}
