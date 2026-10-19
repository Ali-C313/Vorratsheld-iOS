//
//  UserRepository.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

protocol UserRepository {
    // nil, wenn noch kein Profil gespeichert ist
    func fetchUser(id: String) async throws -> FireUser?
    func saveUser(_ user: FireUser, id: String) throws
    func deleteUser(id: String) async throws
}
