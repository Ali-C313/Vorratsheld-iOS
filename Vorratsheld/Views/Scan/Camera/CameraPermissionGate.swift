//
//  CameraPermissionGate.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import AVFoundation
import SwiftUI

struct CameraPermissionGate<Content: View>: View {
    @ViewBuilder var content: () -> Content

    @State private var status = AVCaptureDevice.authorizationStatus(for: .video)

    var body: some View {
        switch status {
        case .authorized:
            content()
        case .notDetermined:
            // Beim ersten Mal fragt iOS selbst (Text aus der Info.plist)
            Color.black
                .task {
                    _ = await AVCaptureDevice.requestAccess(for: .video)
                    status = AVCaptureDevice.authorizationStatus(for: .video)
                }
        default:
            // Abgelehnt, geht nur noch über die Einstellungen
            VStack(spacing: 16) {
                Text(S.scanNoPermission)
                    .font(.body)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Button(S.scanOpenSettings) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        }
    }
}
