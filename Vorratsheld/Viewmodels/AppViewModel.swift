//
//  AppViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import Observation

@MainActor
@Observable
class AppViewModel {

    enum Stage {
        case splash, onboarding, main
    }

    var stage: Stage = .splash
    var path: [Route] = []
    var authPath: [AuthRoute] = []
    // Ändert sich die Sprache, baut sich die ganze Oberfläche neu auf
    var languageCode: String? = AppSettings.language

    var introDone: Bool {
        stage == .main
    }

    func finishSplash() {
        stage = AppSettings.onboardingDone ? .main : .onboarding
    }

    func finishOnboarding() {
        AppSettings.onboardingDone = true
        stage = .main
    }

    func navigate(to route: Route) {
        path.append(route)
    }

    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func navigateToRoot() {
        path.removeAll()
    }

    // Vom Scanner zu den Details, ohne dass man zum Scanner zurückkommt
    func replaceLast(with route: Route) {
        navigateBack()
        path.append(route)
    }

    func setLanguage(_ code: String?) {
        L.setLanguage(code)
        languageCode = code
    }

    func reset() {
        path.removeAll()
        authPath.removeAll()
    }
}
