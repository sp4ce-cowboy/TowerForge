//
//  FirebaseRepository.swift
//  TowerForge
//
//  Created by Vanessa Mae on 02/04/24.
//

import Foundation
import FirebaseDatabase
import Combine

final class FirebaseRepository: FirebaseRepositoryProtocol {

    // Change the design to make it more general
    func getData<T>(from collection: FirebaseReference,
                    completion: @escaping (Result<T?, Error>) -> Void) where T: Decodable {
            let databaseReference = FirebaseDatabaseReference(collection)

            // Assuming that `collection` represents a specific path in the database
            databaseReference.observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value else {
                    // If snapshot value is nil, return nil through completion
                    completion(.success(nil))
                    return
                }

                do {
                    // Convert the snapshot's value to type T
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(decodedData))
                } catch {
                    // If decoding fails, return the error through completion
                    completion(.failure(error))
                }
            }
        }

    func postData<T>(data: T, from collection: FirebaseReference) throws where T: Encodable {
            let databaseReference = FirebaseDatabaseReference(collection)

            // Convert the data object to a dictionary
            let encoder = JSONEncoder()
            guard let jsonData = try? encoder.encode(data),
                  let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
                  let jsonDictionary = jsonObject as? [String: Any] else {
                throw ErrorMessage.failedSnapshot
            }
            let childReference = databaseReference.childByAutoId()
            // Set the data at the specified path using the unique identifier as the key
            childReference.setValue(jsonDictionary)
        }
}
