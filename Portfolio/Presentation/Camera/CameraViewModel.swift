//
//  CameraViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//

import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var photo: UIImage?
    @Published var isTaken = false
    @Published var alertError = false
    @Published var isSaved = false
    @Published var currentCameraPosition: AVCaptureDevice.Position = .back

    private let output = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?

    // MARK: - Camera Authorization

    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
                self.isCameraAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.isCameraAuthorized = granted
            }
        default:
            self.isCameraAuthorized = false
        }
    }

    // MARK: - Session Configuration

    func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        // Remove existing inputs
        if let currentInput = session.inputs.first {
            session.removeInput(currentInput)
        }

        // Add new input based on current camera position
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition) else {
            print("Error: No camera available for position \(currentCameraPosition).")
            session.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print("Error: Unable to add input to session.")
            session.commitConfiguration()
            return
        }

        // Add the photo output if not already added
        if session.outputs.isEmpty {
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
        }

        session.commitConfiguration()
    }

    func startSession() {
        if !session.isRunning {
           DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
           }
        }
    }

    func stopSession() {
        if session.isRunning {
            self.session.stopRunning()
        }
    }

    // MARK: - Camera Switching

    func switchCamera() {
        // Toggle camera position
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back

        // Reconfigure session with new camera
        setupSession()
    }

    // MARK: - Capture Photo

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    // MARK: - AVCapturePhotoCaptureDelegate Methods

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {

        if let error = error {
            print("Error capturing photo: \(error)")
            self.alertError = true
            return
        }

        guard
            let sampleBuffer = photoSampleBuffer,
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer,
                                                                             previewPhotoSampleBuffer: previewPhotoSampleBuffer),
            let image = UIImage(data: imageData)
        else {
            self.alertError = true
            return
        }

            self.photo = image
            self.isTaken = true
            self.stopSession()
    }

    // MARK: - Observers

    @Published var isCameraAuthorized = false {
        didSet {
            if isCameraAuthorized {
                setupSession()
                startSession()
            }
        }
    }
}
