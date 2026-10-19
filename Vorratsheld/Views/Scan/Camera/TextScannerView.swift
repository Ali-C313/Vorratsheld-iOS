//
//  TextScannerView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import AVFoundation
import SwiftUI
import Vision

// Texterkennung mit Vision
struct TextScannerView: UIViewRepresentable {
    var torchEnabled: Bool
    var onTextRecognized: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> CameraPreviewView {
        let coordinator = context.coordinator
        coordinator.onText = onTextRecognized
        return CameraPreviewView { session in
            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            guard session.canAddOutput(output) else { return }
            session.addOutput(output)
            output.setSampleBufferDelegate(coordinator, queue: coordinator.queue)
        }
    }

    func updateUIView(_ view: CameraPreviewView, context: Context) {
        context.coordinator.onText = onTextRecognized
        view.setTorch(torchEnabled)
    }

    static func dismantleUIView(_ view: CameraPreviewView, coordinator: Coordinator) {
        view.stop()
    }

    // Höchstens ca. zweimal pro Sekunde auslesen
    final class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        let queue = DispatchQueue(label: "vorratsheld.ocr")
        var onText: ((String) -> Void)?
        private var lastRun = Date.distantPast

        func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection
        ) {
            guard Date().timeIntervalSince(lastRun) >= 0.4 else { return }
            lastRun = Date()
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            // Bilder kommen bei Hochformat um 90° gedreht
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
            try? handler.perform([request])

            let text = (request.results ?? [])
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            guard !text.isEmpty else { return }
            DispatchQueue.main.async { [weak self] in
                self?.onText?(text)
            }
        }
    }
}
