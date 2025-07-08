//
//  PDFViewerViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/01/25.
//


import SwiftUI
import PDFKit

class PDFViewerViewModel: ObservableObject {
    @Published var isRemote: Bool = false
    @Published var pdfDocument: PDFDocument?
    @Published var errorMessage: String?
    @Published var pdfUrl: URL?
    @Published var data: Data?

    func loadPDF(from url: URL) {
        isRemote = false
        pdfUrl = url
        guard let pdfDocument = PDFDocument(url: url) else {
            errorMessage = "Failed to load the PDF document."
            return
        }
        self.pdfDocument = pdfDocument
        do {
            let newData = try Data(contentsOf: url)
            data = newData
        } catch {
            print(error)
        }
    }

    func loadRemotePDF(from remoteURL: URL) {
        isRemote = true
        PDFServices.shared.pdfSession.request(remoteURL, method: .get)
            .validate() // optional
            .responseData { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let data):
                    // data is cached if the server returns caching headers
                    guard let doc = PDFDocument(data: data) else {
                        print("Failed to parse PDF.")
                        errorMessage = "Failed to parse PDF data."
                        return
                    }

                    self.pdfDocument = doc
                    self.data = data
                    self.pdfUrl = remoteURL
                    // update UI or store pdfDoc, etc.
                case .failure(let error):
                    print("Error downloading PDF: \(error)")
                    self.errorMessage = error.localizedDescription
                }
            }
    }

    func extractPDFData() -> Data? {
        return pdfDocument?.dataRepresentation()
    }
}
