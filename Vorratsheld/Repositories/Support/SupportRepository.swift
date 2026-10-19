//
//  SupportRepository.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

protocol SupportRepository {
    func send(_ request: SupportRequest) async throws
}
