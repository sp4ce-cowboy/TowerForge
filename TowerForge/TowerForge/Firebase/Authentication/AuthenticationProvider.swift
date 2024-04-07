//
//  AuthenticationProvider.swift
//  TowerForge
//
//  Created by MacBook Pro on 08/04/24.
//

import Foundation

class AuthenticationProvider {
    private let authenticationManager: AuthenticationManager
    init(authenticationManager: AuthenticationManager = AuthenticationManager(), delegate: AuthenticationDelegate) {
        self.authenticationManager = authenticationManager
        self.authenticationManager.setListener(delegate: delegate)
    }
    func login(email: String, password: String, completion: @escaping (AuthenticationData?, Error?) -> Void) {
        self.authenticationManager.loginUser(email: email,
                                             password: password,
                                             completion: completion)
    }
    func register(email: String, username: String, password: String, completion: @escaping (AuthenticationData?, Error?) -> Void) {
        self.authenticationManager.registerUser(email: email, username: username, password: password, onFinish: completion)
    }
    func logout(completion: @escaping (Error?) -> Void){
        self.authenticationManager.logoutUser(completion: completion)
    }
}
