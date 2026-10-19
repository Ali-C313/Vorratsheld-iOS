//
//  SupportRepositoryMock.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class SupportRepositoryMock: SupportRepository {

    func send(_ request: SupportRequest) async throws {
        print("Mock: Anfrage \"\(request.subject)\" verschickt")
    }
}
