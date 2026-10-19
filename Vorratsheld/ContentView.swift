//
//  ContentView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ContentView: View {

    // ViewModels für die ganze App, werden per .environment weitergegeben
    @State private var appViewModel = AppViewModel()
    @State private var userViewModel = UserViewModel(
        authRepository: AuthRepositoryImpl(),
        userRepository: UserRepositoryImpl(),
        productRepository: ProductRepositoryImpl(),
        shoppingRepository: ShoppingRepositoryImpl()
    )
    @State private var productViewModel = ProductViewModel(
        productRepository: ProductRepositoryImpl(),
        shoppingRepository: ShoppingRepositoryImpl(),
        authRepository: AuthRepositoryImpl()
    )
    @State private var lockViewModel = LockViewModel()

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            switch appViewModel.stage {
            case .splash:
                SplashView {
                    appViewModel.finishSplash()
                }
            case .onboarding:
                OnboardingView {
                    appViewModel.finishOnboarding()
                }
            case .main:
                if userViewModel.isUserLoggedIn {
                    NavigationStack(path: $appViewModel.path) {
                        HomeView()
                            .navigationDestination(for: Route.self) { route in
                                destination(for: route)
                            }
                    }
                } else {
                    NavigationStack(path: $appViewModel.authPath) {
                        LoginView()
                            .navigationDestination(for: AuthRoute.self) { _ in
                                RegisterView()
                            }
                    }
                }
            }

            // Sperre erst nach dem Splash und nur, wenn jemand eingeloggt ist
            if lockViewModel.isLocked && appViewModel.introDone && userViewModel.isUserLoggedIn {
                LockView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: lockViewModel.isLocked)
        .environment(appViewModel)
        .environment(userViewModel)
        .environment(productViewModel)
        .environment(lockViewModel)
        // Bei Sprachwechsel wird alles neu aufgebaut, Arabisch von rechts nach links
        .environment(\.locale, L.locale)
        .environment(\.layoutDirection, L.isRightToLeft ? .rightToLeft : .leftToRight)
        .id(appViewModel.languageCode ?? "system")
        .tint(AppColor.primary)
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                lockViewModel.onBackground()
            }
            if phase == .active {
                lockViewModel.onForeground()
            }
        }
        .onChange(of: userViewModel.isUserLoggedIn) { _, loggedIn in
            if !loggedIn {
                productViewModel.stopListening()
                appViewModel.reset()
                lockViewModel.unlock()
            }
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .scan:
            ScanView()
        case .settings:
            SettingsView()
        case .editProfile:
            EditProfileView()
        case .language:
            LanguageView()
        case .help:
            HelpView(supportViewModel: SupportViewModel(
                supportRepository: SupportRepositoryImpl(),
                authRepository: AuthRepositoryImpl()
            ))
        case .securitySettings:
            AppLockSettingsView()
        case .legal(let type):
            LegalView(type: type)
        case .productDetail(let productId, let barcode):
            ProductDetailView(
                productId: productId,
                barcode: barcode,
                productDetailViewModel: ProductDetailViewModel(productInfoRepository: ProductInfoRepositoryImpl())
            )
        case .productInfo(let productId):
            ProductInfoView(productId: productId)
        case .shoppingList:
            ShoppingListView(shoppingListViewModel: ShoppingListViewModel(
                shoppingRepository: ShoppingRepositoryImpl(),
                authRepository: AuthRepositoryImpl()
            ))
        }
    }
}
