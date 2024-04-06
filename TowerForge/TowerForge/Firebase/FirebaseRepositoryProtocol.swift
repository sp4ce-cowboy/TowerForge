//
//  FirebaseRepositoryProtocol.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation
import FirebaseDatabase
import Combine

typealias EncodableIndentifiableType = Encodable

protocol FirebaseRepositoryProtocol {
    func getData<T: Decodable>(from collection: FirebaseReference, completion: @escaping (Result<T?, Error>) -> Void)
    // To save, we need to have an id
    func postData<T: EncodableIndentifiableType>(data: T, from collection: FirebaseReference) throws

}
