//
//  BarcodeScannerView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import AVFoundation
import SwiftUI

struct BarcodeScannerView: UIViewRepresentable {
    var torchEnabled: Bool
    var onBarcodeDetected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> CameraPreviewView {
        let coordinator = context.coordinator
        coordinator.onCode = onBarcodeDetected
        return CameraPreviewView { session in
            let output = AVCaptureMetadataOutput()
            guard session.canAddOutput(output) else { return }
            session.addOutput(output)
            output.setMetadataObjectsDelegate(coordinator, queue: .main)
            // Typen erst nach addOutput setzen, sonst Absturz
            let wanted: [AVMetadataObject.ObjectType] = [.ean13, .ean8, .upce, .code128]
            output.metadataObjectTypes = wanted.filter { output.availableMetadataObjectTypes.contains($0) }
        }
    }

    func updateUIView(_ view: CameraPreviewView, context: Context) {
        context.coordinator.onCode = onBarcodeDetected
        view.setTorch(torchEnabled)
    }

    static func dismantleUIView(_ view: CameraPreviewView, coordinator: Coordinator) {
        view.stop()
    }

    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var onCode: ((String) -> Void)?
        private var alreadyDetected = false

        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            guard !alreadyDetected,
                  let code = metadataObjects.compactMap({ $0 as? AVMetadataMachineReadableCodeObject }).first?.stringValue
            else { return }
            alreadyDetected = true
            onCode?(code)
        }
    }
}
