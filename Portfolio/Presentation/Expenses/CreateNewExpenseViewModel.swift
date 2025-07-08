//
//  CreateNewExpenseViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 25/01/25.
//

import SwiftUI
import PDFKit
import Combine

class CreateNewExpenseViewModel: ObservableObject {
    @Published var expenseName: CustomTextFieldViewModel = .init(data: "",
                                                                 placeholder: "Expense Name",
                                                                 componentName: "Expense Name",
                                                                 validator: DefaultFormInputTextValidator())
    @Published var expenseValue: CustomTextFieldViewModel = .init(data: "",
                                                                  placeholder: "Expense Value",
                                                                  componentName: "Expense Name",
                                                                  validator: DefaultFormInputTextValidator())

    @Published var typeAttachment: DropdownViewModel = .init(placeholder: "Type of attachment",
                                                             componentName: "Type of attachment") {
        return AttachmentType.allCases.enumerated().map { DropdownItem(id: $0.element.rawValue,
                                                                       value: $0.element.rawValue.capitalized, index: $0.offset) }
    }

    @Published var description: CustomTextFieldViewModel = CustomTextFieldViewModel(
        data: "",
        placeholder: String.localized(.descriptionOptional),
        componentName: "Description",
        validator: EmptyFormInputTextValidator()
    )
    @Published var date: Date = .now {
        didSet {
            isDateValid = true
        }
    }
    @Published var hasAttachedDocument: Bool = false
    @Published var focosId: String? = nil
    @Published var showDocumentPicker: Bool = false
    @Published var pdfDocument: PDFDocument? = nil
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
                pdfViewerViewModel.loadRemotePDF(from: url)
            }
        }
    }

    // MARK: Validation States
    @Published var isDateValid: Bool = true
    @Published var isPdfValid: Bool = false
    @Published var isDescriptionValid: Bool = false
    @Published var isSaveButtonEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var formError: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var attachmentAssociatedId: Int?
    @Published var isDateAlreadyEdited: Bool = false

    var minimumDate: Date.MonthRange? {
        return date.monthBounds()
    }

    private var assetId: Int


    let saveAttachmentUseCase: SaveAttachmentUseCaseProtocol
    var onSave: (()->Void)?

    init(
        assetId: Int,
        attachmentAssociatedId: Int? = nil,
        pdfUrl: URL? = nil,
        remoteUrl: URL? = nil,
        date: Date? = nil,
        saveAttachmentUseCase: SaveAttachmentUseCaseProtocol = SaveAttachmentUseCase(repository: AttachmentRepository())
    ) {
        self.saveAttachmentUseCase = saveAttachmentUseCase
        self.assetId = assetId
        self.attachmentAssociatedId = attachmentAssociatedId
        self.pdfUrl = pdfUrl
        self.remoteUrl = remoteUrl
        if date != nil {
            self.date = date ?? .now
            self.isDateAlreadyEdited = true
        }
        setupValidationBindings()
    }

    func resetData() {
        expenseName = .init(data: "",
                               placeholder: "Expense Name",
                               componentName: "Expense Name",
                               validator: DefaultFormInputTextValidator())

        expenseValue = .init(data: "",
                             placeholder: "Expense Value",
                             componentName: "Expense Name",
                             validator: DefaultFormInputTextValidator())

        description = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.descriptionOptional),
            componentName: "Description",
            validator: EmptyFormInputTextValidator()
        )

        pdfUrl = nil
        remoteUrl = nil
    }

    private func setupValidationBindings() {
        // Validate `description`
        expenseName
            .isComponentReadySubject
            .combineLatest(typeAttachment.isComponentReadySubject)
            .map { $0.0 && $0.1 }
            .removeDuplicates()
            .assign(to: &$isDescriptionValid)

        // Combine all validations to enable/disable the save button
        Publishers.CombineLatest(expenseValue.isComponentReadySubject, $isDescriptionValid)
            .map { isExpenseValue, isDescriptionValid in
                isExpenseValue && isDescriptionValid
            }
            .assign(to: &$isSaveButtonEnabled)
    }

    func saveAttachment() {
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                }

                var pdfData: Data?
                if attachmentAssociatedId == nil {
                    pdfData = pdfViewerViewModel.data
                }

                let attachment = NewAttachmentModel(
                    value: Double(expenseValue.data) ?? 0,
                    type: AttachmentType(rawValue: typeAttachment.data.id) ?? .other,
                    isCreatedAsAttachment: attachmentAssociatedId == nil,
                    name: expenseName.data,
                    documents: pdfData,
                    dateDomain: date,
                    assetId: assetId,
                    attachmentAssociatedId: attachmentAssociatedId
                )

                try await saveAttachmentUseCase.saveAttachment(attachment)
                await MainActor.run {
                    isLoading = false
                    onSave?()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    formError = if let networkError = error as? NetworkError {
                        "We could not save your asset, there is an error: \(networkError)"
                    } else {
                        error.localizedDescription
                    }
                    showErrorAlert = true
                }

            }
        }
    }
}
