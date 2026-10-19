//
//  LockView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct LockView: View {

    @Environment(LockViewModel.self) private var lockViewModel
    @Environment(UserViewModel.self) private var userViewModel

    private let attemptsBeforeWait = 5

    @State private var entered = ""
    @State private var errorText: String?
    @State private var shakeTrigger = 0
    @State private var failedAttempts = 0
    @State private var waitSeconds = 0
    @State private var checking = false
    @State private var showForgotAlert = false

    private var biometricType: BiometricType {
        AppLockSettings.biometricsEnabled ? lockViewModel.biometricType : .unavailable
    }

    var body: some View {
        ZStack {
            AppColor.headerGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    VorratsheldLogo()
                        .frame(width: 96, height: 96)
                        .padding(.bottom, 20)

                    PinPad(
                        title: S.lockTitle,
                        subtitle: S.lockEnterPin,
                        entered: entered,
                        onDigit: onDigit,
                        onDelete: {
                            if !entered.isEmpty {
                                entered.removeLast()
                            }
                            errorText = nil
                        },
                        errorText: waitSeconds > 0 ? S.lockWait(waitSeconds) : (errorText ?? lockViewModel.errorMessage),
                        shakeTrigger: shakeTrigger,
                        enabled: waitSeconds == 0 && !checking
                    ) {
                        if biometricType != .unavailable {
                            PadIconKey(icon: BiometricHelper.icon(biometricType), description: BiometricHelper.label(biometricType)) {
                                askBiometric()
                            }
                        }
                    }

                    Button(S.lockForgotPin) {
                        showForgotAlert = true
                    }
                    .foregroundStyle(AppColor.cream)
                    .padding(.top, 12)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .onAppear {
            if biometricType != .unavailable {
                askBiometric()
            }
        }
        // Nach zu vielen Fehlversuchen herunterzählen
        .task(id: waitSeconds) {
            guard waitSeconds > 0 else { return }
            try? await Task.sleep(for: .seconds(1))
            waitSeconds -= 1
        }
        .alert(S.lockForgotPin, isPresented: $showForgotAlert) {
            Button(S.settingsLogout, role: .destructive) {
                userViewModel.logout()
            }
            Button(S.actionCancel, role: .cancel) {}
        } message: {
            Text(S.lockForgotText)
        }
    }

    private func askBiometric() {
        Task {
            if await lockViewModel.authenticate() {
                lockViewModel.unlock()
            }
        }
    }

    private func onDigit(_ digit: Character) {
        guard !checking, entered.count < AppLockSettings.pinLength else { return }
        entered.append(digit)
        errorText = nil
        guard entered.count == AppLockSettings.pinLength else { return }

        let pin = entered
        checking = true
        Task {
            // Hash dauert etwas, deshalb nicht auf dem Main-Thread
            let correct = await Task.detached { AppLockSettings.checkPin(pin) }.value
            checking = false
            if correct {
                lockViewModel.unlock()
            } else {
                failedAttempts += 1
                shakeTrigger += 1
                entered = ""
                errorText = S.lockWrongPin
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                if failedAttempts % attemptsBeforeWait == 0 {
                    // Jede weitere Runde Fehlversuche wartet länger
                    waitSeconds = 30 * (failedAttempts / attemptsBeforeWait)
                }
            }
        }
    }
}

#Preview {
    LockView()
        .environment(LockViewModel())
        .environment(PreviewData.userViewModel)
}
