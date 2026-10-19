//
//  CameraPreviewView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import AVFoundation
import UIKit

// Kamera-Vorschau, die Erkennung wird als Output an die Session gehängt
final class CameraPreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

    private let session = AVCaptureSession()
    private let device = AVCaptureDevice.default(for: .video)
    private let sessionQueue = DispatchQueue(label: "vorratsheld.camera")

    private var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    init(addOutputs: (AVCaptureSession) -> Void) {
        super.init(frame: .zero)
        backgroundColor = .black
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill

        session.beginConfiguration()
        if let device, let input = try? AVCaptureDeviceInput(device: device), session.canAddInput(input) {
            session.addInput(input)
        }
        addOutputs(session)
        session.commitConfiguration()

        // startRunning blockiert, deshalb nicht auf dem Main-Thread
        sessionQueue.async { [session] in
            session.startRunning()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) wird nicht benutzt")
    }

    func stop() {
        sessionQueue.async { [session] in
            session.stopRunning()
        }
    }

    // Geht nur bei laufender Kamera
    func setTorch(_ on: Bool) {
        guard let device, device.hasTorch else { return }
        sessionQueue.async {
            guard (try? device.lockForConfiguration()) != nil else { return }
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        }
    }
}
