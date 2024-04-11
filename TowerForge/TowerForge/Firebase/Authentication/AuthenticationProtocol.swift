//
//  AuthenticationProtocol.swift
//  TowerForge
//
//  Created by Vanessa Mae on 08/04/24.
//

import Foundation

struct AuthenticationData {
    let userId: String
    let email: String
    let username: String?
}

protocol AuthenticationProtocol {
    func loginUser(email: String, password: String,
                   completion: @escaping (AuthenticationData?, Error?) -> Void)
    func logoutUser(completion: @escaping (Error?) -> Void)
    func registerUser(email: String,
                      username: String,
                      password: String,
                      onFinish: @escaping (AuthenticationData?, Error?) -> Void)
    func getUserData(completion: @escaping (AuthenticationData?, Error?) -> Void)
    func getCurrentUserAuthData() -> AuthenticationData?
}
