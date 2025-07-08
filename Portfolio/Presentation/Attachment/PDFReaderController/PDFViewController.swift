//
//  PDFViewController.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 9/01/25.
//
import UIKit
import PDFKit

class PDFViewController: UIViewController, UIDocumentPickerDelegate {

    // MARK: - Properties
    var pdfView: PDFView!
    var viewModel: PDFViewerViewModel?
    var pdfDocument: PDFDocument? {
        didSet {
            pdfView.document = pdfDocument
        }
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPDFView()
    }

    // MARK: - Setup Methods

    private func setupPDFView() {
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .lightGray
        view.addSubview(pdfView)

        // Constraints
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50) // Leave space for toolbar
        ])
    }

    func displayRemotePDF(remoteURL: URL) {
        PDFServices.shared.pdfSession.request(remoteURL, method: .get)
            .validate() // optional
            .responseData { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let data):
                    // data is cached if the server returns caching headers
                    guard let pdfDoc = PDFDocument(data: data) else {
                        print("Failed to parse PDF.")
                        return
                    }

                    self.pdfDocument = pdfDoc
                    self.viewModel?.pdfUrl = remoteURL
                    self.viewModel?.pdfDocument = pdfDoc
                    self.viewModel?.data = data
                    // update UI or store pdfDoc, etc.
                case .failure(let error):
                    print("Error downloading PDF: \(error)")
                }
            }
    }


    /// Displays a PDF from a given URL
    /// - Parameter url: URL of the PDF document
    func displayPDF(url: URL?) {
        guard let url = url else {
            print("Failed to load the PDF document.")
            return
        }
        Task {
            do {
                // Read the file data in a background task
                let newData = try Data(contentsOf: url)
                await MainActor.run {

                // Parse the PDF
                guard let pdfDocument = PDFDocument(data: newData) else {
                    print("Failed to load PDF document from local data.")
                    return
                }

                // Update UI and viewModel on the main actor
                    self.pdfDocument = pdfDocument
                    self.viewModel?.pdfUrl = url
                    self.viewModel?.pdfDocument = pdfDocument
                    self.viewModel?.data = newData
                }
            } catch {
                print("Error reading local PDF file: \(error)")
            }
        }
    }
}
