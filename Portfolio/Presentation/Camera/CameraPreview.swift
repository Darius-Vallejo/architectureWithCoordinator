//
//  CameraPreview.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 26/11/24.
//


import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraViewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        cameraViewModel.previewLayer = AVCaptureVideoPreviewLayer(session: cameraViewModel.session)
        cameraViewModel.previewLayer?.videoGravity = .resizeAspectFill

        if let previewLayer = cameraViewModel.previewLayer {
            previewLayer.frame = UIScreen.main.bounds
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            cameraViewModel.previewLayer?.frame = uiView.bounds
        }
    }
}
