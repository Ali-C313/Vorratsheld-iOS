//
//  AppLockSettingsView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct AppLockSettingsView: View {

    @Environment(LockViewModel.self) private var lockViewModel

    @State private var enabled = AppLockSettings.enabled
    @State private var biometrics = AppLockSettings.biometricsEnabled
    @State private var timeout = AppLockSettings.timeout
    @State private var pinFlow: PinFlowMode?

    private var biometricType: BiometricType {
        lockViewModel.biometricType
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Image(systemName: biometricType != .unavailable ? BiometricHelper.icon(biometricType) : "lock.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(AppColor.onPrimaryContainer)
                        .frame(width: 88, height: 88)
                        .background(AppColor.primaryContainer, in: Circle())
                    Text(S.applockIntro)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }

            Section {
                // An und aus nur mit PIN
                Toggle(isOn: Binding(
                    get: { enabled },
                    set: { on in pinFlow = on ? .create : .disable }
                )) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(S.applockEnable)
                        Text(S.applockEnableHint)
                            .font(.subheadline)
                            .foregroundStyle(AppColor.onSurfaceVariant)
                    }
                }
            }

            if enabled {
                Section {
                    if biometricType != .unavailable {
                        Toggle(S.applockUnlockWith(BiometricHelper.label(biometricType)), isOn: Binding(
                            get: { biometrics },
                            set: { on in setBiometrics(on) }
                        ))
                    } else {
                        Text(S.applockNoBiometrics)
                            .font(.subheadline)
                            .foregroundStyle(AppColor.onSurfaceVariant)
                    }

                    Picker(S.applockTimeout, selection: $timeout) {
                        ForEach(LockTimeout.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }

                    SettingsItem(icon: "key.fill", title: S.applockChangePin) {
                        pinFlow = .change
                    }
                }
            }
        }
        .navigationTitle(S.applockTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: timeout) { _, value in
            AppLockSettings.timeout = value
        }
        .fullScreenCover(item: $pinFlow) { mode in
            PinFlowView(
                mode: mode,
                onFinished: { finish(mode) },
                onCancel: { pinFlow = nil }
            )
        }
    }

    private func finish(_ mode: PinFlowMode) {
        switch mode {
        case .create:
            enabled = true
            if biometricType != .unavailable {
                AppLockSettings.biometricsEnabled = true
                biometrics = true
            }
        case .disable:
            AppLockSettings.clear()
            enabled = false
            biometrics = false
        case .change:
            break
        }
        pinFlow = nil
    }

    private func setBiometrics(_ on: Bool) {
        guard on else {
            AppLockSettings.biometricsEnabled = false
            biometrics = false
            return
        }
        // Einmal testen, ob es klappt
        Task {
            if await lockViewModel.authenticate() {
                AppLockSettings.biometricsEnabled = true
                biometrics = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppLockSettingsView()
    }
    .environment(LockViewModel())
}
