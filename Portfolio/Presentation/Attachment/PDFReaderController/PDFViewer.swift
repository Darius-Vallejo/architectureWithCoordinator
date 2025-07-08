//
//  PDFViewer.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//


import SwiftUI
import PDFKit
import UniformTypeIdentifiers
import UIKit

struct PDFViewer: UIViewControllerRepresentable {

    var viewModel: PDFViewerViewModel
    var url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    func makeUIViewController(context: Context) -> PDFViewController {
        let documentPicker = PDFViewController()
        _ = documentPicker.view
        documentPicker.viewDidLoad()
        if viewModel.isRemote {
            documentPicker.displayRemotePDF(remoteURL: url)
        } else {
            documentPicker.displayPDF(url: url)
        }
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: PDFViewController, context: Context) {
        if viewModel.isRemote {
            uiViewController.displayRemotePDF(remoteURL: url)
        } else {
            uiViewController.displayPDF(url: url)
        }
    }

    class Coordinator: NSObject {
        var url: URL

        init(url: URL) {
            self.url = url
        }
    }
}
