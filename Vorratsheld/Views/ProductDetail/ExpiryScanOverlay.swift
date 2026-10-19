//
//  ExpiryScanOverlay.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ExpiryScanOverlay: View {
    let onDateConfirmed: (Int64) -> Void
    let onManualPick: () -> Void
    let onClose: () -> Void

    @State private var lastSeen: LocalDay?
    @State private var detected: LocalDay?
    @State private var torchEnabled = false

    var body: some View {
        ZStack {
            CameraPermissionGate {
                TextScannerView(torchEnabled: torchEnabled) { text in
                    let date = ExpiryDateParser.parse(text)
                    // Erst übernehmen, wenn zwei Bilder hintereinander dasselbe Datum liefern
                    if let date, date == lastSeen, detected != date {
                        withAnimation(.spring(duration: 0.3)) { detected = date }
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                    lastSeen = date
                }
            }
            .ignoresSafeArea()

            TextFrame(found: detected != nil)
                .padding(.bottom, 160)

            VStack(spacing: 0) {
                HStack {
                    CircleIconButton(icon: "xmark", description: S.actionBack, action: onClose)
                    Spacer()
                    TorchButton(enabled: torchEnabled) { torchEnabled.toggle() }
                }
                .padding(16)

                Spacer()

                bottomSheet
            }
        }
        .background(Color.black)
    }

    private var bottomSheet: some View {
        VStack(spacing: 0) {
            Group {
                if let detected {
                    VStack(spacing: 4) {
                        Text(S.expiryScanDetected)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppColor.onSurfaceVariant)
                        Text(DateHelper.formatDate(detected.millis))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(AppColor.primary)
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                } else {
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            ProgressView()
                            Text(S.expiryScanSearching)
                                .font(.headline)
                        }
                        Text(S.expiryScanHint)
                            .font(.subheadline)
                            .foregroundStyle(AppColor.onSurfaceVariant)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(minHeight: 70)

            PrimaryButton(text: S.actionApply) {
                if let detected { onDateConfirmed(detected.millis) }
            }
            .disabled(detected == nil)
            .opacity(detected == nil ? 0.5 : 1)
            .padding(.top, 16)

            Button(action: onManualPick) {
                Label(S.expiryScanManual, systemImage: "calendar")
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .fill(AppColor.surface)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
