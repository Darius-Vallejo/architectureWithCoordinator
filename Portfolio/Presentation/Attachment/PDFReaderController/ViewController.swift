//
//  ViewController.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 9/01/25.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

// Define the annotation subtypes for better type safety
enum PDFAnnotationType: String {
    case highlight = "Highlight"
    // You can add more types like underline, strikeOut, etc.
}

class PDFReaderViewController: UIViewController, UIDocumentPickerDelegate {

    // MARK: - Properties

    var pdfView: PDFView!
    var toolbar: UIToolbar!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPDFView()
        setupToolbar()
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

    private func setupToolbar() {
        toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)

        // Toolbar items
        let openButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openDocumentPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let previousButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goToPreviousPage))
        let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(goToNextPage))
        let highlightButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addHighlight))
        let removeHighlightButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeHighlights))

        toolbar.items = [openButton, flexibleSpace, previousButton, nextButton, flexibleSpace, highlightButton, removeHighlightButton]

        // Constraints
        NSLayoutConstraint.activate([
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - PDF Display Methods

    /// Displays a PDF from a given URL
    /// - Parameter url: URL of the PDF document
    func displayPDF(url: URL) {
        guard let pdfDocument = PDFDocument(url: url) else {
            presentAlert(title: "Error", message: "Failed to load the PDF document.")
            return
        }
        pdfView.document = pdfDocument
    }

    // MARK: - Document Picker Methods

    /// Presents the UIDocumentPickerViewController to allow PDF selection
    @objc func openDocumentPicker() {
        let documentPicker: UIDocumentPickerViewController
        let pdfType = UTType.pdf

        if #available(iOS 14.0, *) {
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [pdfType], asCopy: true)
        } else {
            documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        }

        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }

    // MARK: - UIDocumentPickerDelegate Methods

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        displayPDF(url: url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Optionally handle cancellation
    }

    // MARK: - PDFKit Feature Methods

    /// Navigate to the previous page
    @objc func goToPreviousPage() {
        pdfView.goToPreviousPage(nil)
    }

    /// Navigate to the next page
    @objc func goToNextPage() {
        pdfView.goToNextPage(nil)
    }

    /// Add a highlight annotation to the current page
    @objc func addHighlight() {
        guard let page = pdfView.currentPage else { return }

        // Define the area to highlight (for demo purposes, fixed bounds)
        let annotationBounds = CGRect(x: 100, y: 100, width: 200, height: 50)

        // Create a highlight annotation
        let highlight = PDFAnnotation(bounds: annotationBounds, forType: .highlight, withProperties: nil)
        highlight.color = UIColor.yellow.withAlphaComponent(0.5)

        // Add the annotation to the page
        page.addAnnotation(highlight)
    }

    /// Remove all highlight annotations from the current page
    @objc func removeHighlights() {
        guard let page = pdfView.currentPage else { return }

        // Filter annotations of type 'Highlight'
        let highlights = page.annotations.filter { $0.type == PDFAnnotationType.highlight.rawValue }

        // Remove each highlight annotation
        for highlight in highlights {
            page.removeAnnotation(highlight)
        }
    }

    // MARK: - Helper Methods

    /// Presents an alert with the given title and message
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
}
