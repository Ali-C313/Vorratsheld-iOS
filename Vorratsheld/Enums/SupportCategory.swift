//
//  SupportCategory.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum SupportCategory: String, Codable, CaseIterable, Identifiable {
    case problem = "PROBLEM"
    case feature = "FEATURE"
    case question = "QUESTION"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .problem: return S.helpCategoryProblem
        case .feature: return S.helpCategoryFeature
        case .question: return S.helpCategoryQuestion
        }
    }
}
