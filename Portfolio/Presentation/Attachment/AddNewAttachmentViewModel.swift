//
//  AddNewAttachmentViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI
import PDFKit
import Combine

class AddNewAttachmentViewModel: ObservableObject {
    @Published var expenseName: CustomTextFieldViewModel = .init(data: "",
                                                                 placeholder: "Expense Name",
                                                                 componentName: "Expense Name",
                                                                 validator: DefaultFormInputTextValidator())
    @Published var expenseValue: CustomTextFieldViewModel = .init(data: "",
                                                                  placeholder: "Expense Value (Optional)",
                                                                  componentName: "Expense Name",
                                                                  validator: DefaultFormInputTextValidator())

    @Published var typeAttachment: DropdownViewModel = .init(placeholder: "Type of attachment", componentName: "Type of attachment") {
        return AttachmentType.allCases.enumerated().map { DropdownItem(id: $0.element.rawValue, value: $0.element.rawValue.capitalized, index: $0.offset) }
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

    // MARK: Validation States
    @Published var isDateValid: Bool = false
    @Published var isPdfValid: Bool = false
    @Published var isDescriptionValid: Bool = false
    @Published var isSaveButtonEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var formError: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var isDateAlreadyEdited: Bool = false
    private var assetId: Int


    let saveAttachmentUseCase: SaveAttachmentUseCaseProtocol
    var onSave: (()->Void)?

    init(
        assetId: Int,
        saveAttachmentUseCase: SaveAttachmentUseCaseProtocol = SaveAttachmentUseCase(repository: AttachmentRepository()),
        onSave: (()->Void)? = nil
    ) {
        self.saveAttachmentUseCase = saveAttachmentUseCase
        self.onSave = onSave
        self.assetId = assetId
        setupValidationBindings()
    }

    private func setupValidationBindings() {
        $pdfUrl
            .map { $0 != nil }
            .assign(to: &$isPdfValid)

        // Validate `description`
        expenseName
            .isComponentReadySubject
            .combineLatest(typeAttachment.isComponentReadySubject)
            .map { $0.0 && $0.1 }
            .removeDuplicates()
            .assign(to: &$isDescriptionValid)

        // Combine all validations to enable/disable the save button
        Publishers.CombineLatest($isPdfValid, $isDescriptionValid)
            .map { isPdfValid, isDescriptionValid in
                isPdfValid && isDescriptionValid
            }
            .assign(to: &$isSaveButtonEnabled)
    }

    func saveAttachment() {
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                }
                guard let pdfData = pdfViewerViewModel.data else {
                    throw NSError(domain: "PDF Data Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No PDF data available"])
                }
                let attachment = NewAttachmentModel(
                    value: Double(expenseValue.data) ?? 0,
                    type: AttachmentType(rawValue: typeAttachment.data.id) ?? .other,
                    isCreatedAsAttachment: true,
                    name: expenseName.data,
                    documents: pdfData,
                    dateDomain: isDateAlreadyEdited ? date : nil,
                    assetId: assetId
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
