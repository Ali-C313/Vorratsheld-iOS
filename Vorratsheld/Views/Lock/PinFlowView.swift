//
//  PinFlowView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct PinFlowView: View {
    let mode: PinFlowMode
    let onFinished: () -> Void
    let onCancel: () -> Void

    @State private var step: PinStep
    @State private var entered = ""
    @State private var firstPin = ""
    @State private var errorText: String?
    @State private var shakeTrigger = 0
    @State private var busy = false

    init(mode: PinFlowMode, onFinished: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.mode = mode
        self.onFinished = onFinished
        self.onCancel = onCancel
        _step = State(initialValue: mode == .create ? .new : .verify)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            AppColor.headerGradient.ignoresSafeArea()

            ScrollView {
                PinPad(
                    title: texts.title,
                    subtitle: texts.subtitle,
                    entered: entered,
                    onDigit: onDigit,
                    onDelete: {
                        if !entered.isEmpty { entered.removeLast() }
                        errorText = nil
                    },
                    errorText: errorText,
                    shakeTrigger: shakeTrigger,
                    enabled: !busy
                )
                .padding(.top, 56)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)

            CircleIconButton(icon: "xmark", description: S.actionCancel, background: .clear, foreground: AppColor.cream, action: onCancel)
                .padding(8)
        }
    }

    private var texts: (title: String, subtitle: String) {
        switch step {
        case .verify: return (S.pinCurrent, S.pinCurrentHint)
        case .new: return (S.pinCreate, S.pinCreateHint)
        case .confirm: return (S.pinConfirm, S.pinConfirmHint)
        }
    }

    private func onDigit(_ digit: Character) {
        guard !busy, entered.count < AppLockSettings.pinLength else { return }
        entered.append(digit)
        errorText = nil
        if entered.count == AppLockSettings.pinLength {
            onComplete(entered)
        }
    }

    private func fail(_ message: String) {
        errorText = message
        shakeTrigger += 1
        entered = ""
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    private func onComplete(_ pin: String) {
        switch step {
        case .verify:
            busy = true
            Task {
                let correct = await Task.detached { AppLockSettings.checkPin(pin) }.value
                busy = false
                if !correct {
                    fail(S.lockWrongPin)
                } else if mode == .disable {
                    onFinished()
                } else {
                    step = .new
                    entered = ""
                }
            }
        case .new:
            firstPin = pin
            step = .confirm
            entered = ""
        case .confirm:
            if pin != firstPin {
                step = .new
                fail(S.pinMismatch)
            } else {
                busy = true
                Task {
                    await Task.detached { AppLockSettings.setPin(pin) }.value
                    busy = false
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    PinFlowView(mode: .create, onFinished: {}, onCancel: {})
}
