//
//  AuthenticationProtocol.swift
//  TowerForge
//
//  Created by MacBook Pro on 08/04/24.
//

import Foundation

struct AuthenticationData {
    let userId: String
    let email: String
}

protocol AuthenticationProtocol {
    func loginUser(email: String, password: String,
                   completion: @escaping (AuthenticationData?, Error?) -> Void)
    func logoutUser(completion: @escaping (Error?) -> Void)
    func registerUser(data: AuthenticationData,
                      password: String,
                      completion: @escaping (AuthenticationData?, Error?) -> Void)
    func getUserData(completion: @escaping (AuthenticationData?, Error?) -> Void)
}
