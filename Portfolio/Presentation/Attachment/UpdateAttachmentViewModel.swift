//
//  AddNewAttachmentViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 6/01/25.
//

import SwiftUI
import PDFKit
import Combine

class UpdateAttachmentViewModel: ObservableObject {
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
            isDateAlreadyEdited = true
        }
    }
    @Published var hasAttachedDocument: Bool = false
    @Published var focosId: String? = nil
    @Published var showDocumentPicker: Bool = false
    @Published var pdfDocument: PDFDocument? = nil
    @Published var pdfViewerViewModel = PDFViewerViewModel()
    @Published var pdfUrl: URL?

    // MARK: Validation States
    @Published var isDateValid: Bool = true
    @Published var isDateAlreadyEdited: Bool = true
    @Published var isPdfValid: Bool = false
    @Published var isDescriptionValid: Bool = false
    @Published var isSaveButtonEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var formError: String = ""
    @Published var showErrorAlert: Bool = false
    private var attachment: AttachmentDomainModel
    private let updateExpenseUseCase: UpdateAttachmentUseCaseProtocol

    var onSave: ((_ attachment: AttachmentDomainModel)->Void)?

    init(updateExpenseUseCase: UpdateAttachmentUseCaseProtocol = UpdateAttachmentUseCase(repository: AttachmentRepository()),
         attachment: AttachmentDomainModel,
         onSave: @escaping ((_ attachment: AttachmentDomainModel)->Void)) {
        self.updateExpenseUseCase = updateExpenseUseCase
        self.onSave = onSave
        self.attachment = attachment
        setupValidationBindings()
        setupAttachmentValues(attachment: attachment)
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

    private func setupAttachmentValues(attachment: AttachmentDomainModel) {
        expenseName.data = attachment.name
        expenseValue.data = "\(attachment.value)"
        description.data = attachment.description ?? .empty
        if let dateFromAttachment = attachment.date {
            date = dateFromAttachment
            isDateAlreadyEdited = true
        }
        typeAttachment.setDefaultValue(value: attachment.type.rawValue)
        pdfUrl = attachment.attachmentURL
        if let url = attachment.attachmentURL {
            pdfViewerViewModel.loadRemotePDF(from: url)
            pdfUrl = url
        }
    }

    func setAttachmentUrl(url: URL?) {
        pdfUrl = url
        hasAttachedDocument = true
    }

    func saveAttachment() {
        Task {
            do {
                await MainActor.run {
                    isLoading = true
                }

                var documents: Data?
                if hasAttachedDocument {
                    guard let pdfData = pdfViewerViewModel.data else {
                        throw NSError(domain: "PDF Data Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No PDF data available"])
                    }
                    documents = pdfData
                }

                let attachment = UpdateAttachmentModel(
                    value: Double(expenseValue.data) ?? 0,
                    type: AttachmentType(rawValue: typeAttachment.data.id) ?? .other,
                    name: expenseName.data,
                    documents: documents,
                    dateDomain: date,
                    description: description.data
                )

                let updatedAttachment = try await updateExpenseUseCase.execute(expenseId: self.attachment.id, attachment: attachment)
                await MainActor.run {
                    isLoading = false
                    onSave?(updatedAttachment)
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
