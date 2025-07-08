//
//  NewAttachmentForExpenseViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//

import SwiftUI

class NewAttachmentForExpenseViewModel: ObservableObject {
    typealias ResultOnSave = ((_ result: SavingResult)->Void)?
    @Published var showDocumentPicker: Bool = false
    @Published var pdfViewerViewModel = PDFViewerViewModel()
    @Published var pdfUrl: URL? {
        didSet {
            if let url = pdfUrl {
                pdfViewerViewModel.loadPDF(from: url)
            }
        }
    }
    @Published var remoteUrl: URL? {
        didSet {
            if let url = remoteUrl {
                pdfViewerViewModel.isRemote = true
                pdfViewerViewModel.loadRemotePDF(from: url)
            }
        }
    }

    @Published var attachmentId: Int? = nil

    var save: ResultOnSave

    init(attachment: AttachmentDomainModel? = nil, save: ResultOnSave = nil) {
        self.remoteUrl = attachment?.attachmentURL
        self.attachmentId = attachment?.id
        self.save = save
    }

}

extension NewAttachmentForExpenseViewModel {
    enum SavingResult {
        case fromNewAttachment(url: URL)
        case fromExistingAttachment(attachmentId: Int, remoteUrl: URL)
    }
}

