//
//  ScanView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ScanView: View {

    @Environment(AppViewModel.self) private var appViewModel

    @State private var torchEnabled = false

    var body: some View {
        ZStack {
            CameraPermissionGate {
                BarcodeScannerView(torchEnabled: torchEnabled) { barcode in
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    appViewModel.replaceLast(with: .productDetail(barcode: barcode))
                }
            }
            .ignoresSafeArea()

            ScanFrame()

            VStack {
                HStack {
                    CircleIconButton(icon: "chevron.backward", description: S.actionBack) {
                        appViewModel.navigateBack()
                    }
                    Spacer()
                    TorchButton(enabled: torchEnabled) {
                        torchEnabled.toggle()
                    }
                }
                .padding(16)

                Spacer()

                Text(S.scanHint)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.55), in: Capsule())
                    .padding(.bottom, 32)
            }
        }
        .background(Color.black)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ScanView()
        .environment(AppViewModel())
}
