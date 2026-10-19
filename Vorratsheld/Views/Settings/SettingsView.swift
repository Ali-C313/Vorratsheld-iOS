//
//  SettingsView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct SettingsView: View {

    @Environment(AppViewModel.self) private var appViewModel
    @Environment(UserViewModel.self) private var userViewModel

    @State private var appLockEnabled = AppLockSettings.enabled
    @State private var showLogoutAlert = false

    private var currentLanguage: String {
        AppLanguage(rawValue: appViewModel.languageCode ?? "")?.nativeName ?? S.languageSystem
    }

    var body: some View {
        List {
            Section {
                ProfileCard(user: userViewModel.user, email: userViewModel.email) {
                    appViewModel.navigate(to: .editProfile)
                }
            }

            Section(S.settingsSectionApp) {
                SettingsItem(icon: "globe", title: S.settingsLanguage, subtitle: currentLanguage) {
                    appViewModel.navigate(to: .language)
                }
            }

            Section(S.settingsSectionSecurity) {
                SettingsItem(icon: "lock.fill", title: S.settingsAppLock, subtitle: appLockEnabled ? S.stateOn : S.stateOff) {
                    appViewModel.navigate(to: .securitySettings)
                }
            }

            Section(S.settingsSectionSupport) {
                SettingsItem(icon: "questionmark.circle", title: S.settingsHelp) {
                    appViewModel.navigate(to: .help)
                }
                SettingsItem(icon: "doc.text", title: S.settingsTerms) {
                    appViewModel.navigate(to: .legal(.terms))
                }
                SettingsItem(icon: "hand.raised", title: S.settingsPrivacy) {
                    appViewModel.navigate(to: .legal(.privacy))
                }
                SettingsItem(icon: "info.circle", title: S.settingsImprint) {
                    appViewModel.navigate(to: .legal(.imprint))
                }
            }

            Section {
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    Label(S.settingsLogout, systemImage: "rectangle.portrait.and.arrow.right")
                        .frame(maxWidth: .infinity)
                }
            } footer: {
                Text(S.settingsVersion(PlatformInfo.appVersion))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
        }
        .navigationTitle(S.settingsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            appLockEnabled = AppLockSettings.enabled
        }
        .alert(S.logoutDialogTitle, isPresented: $showLogoutAlert) {
            Button(S.settingsLogout, role: .destructive) {
                userViewModel.logout()
            }
            Button(S.actionCancel, role: .cancel) {}
        } message: {
            Text(S.logoutDialogText)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppViewModel())
    .environment(PreviewData.userViewModel)
}
