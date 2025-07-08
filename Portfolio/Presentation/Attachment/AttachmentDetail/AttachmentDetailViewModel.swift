//
//  AttachmentDetailViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 17/01/25.
//

import SwiftUI
import Combine

class AttachmentDetailViewModel: ObservableObject {
    @Published var attachment: AttachmentDomainModel {
        didSet {
            if let url = attachment.attachmentURL {
                pdfViewModel.loadRemotePDF(from: url)
            }
        }
    }
    @Published var pdfViewModel: PDFViewerViewModel
    @Published var isShowingMenu = false
    @Published var isLoading = false
    @Published var buttonPosition: CGPoint = .zero
    private var cancellables = Set<AnyCancellable>()
    let deleteExpenseUseCase: DeleteExpenseUseCaseProtocol
    private var cancellable = Set<AnyCancellable>()
    var dismiss: (()->Void)?
    var onOpenDetail: (()->Void)?

    var currency: String = {
        CurrentSessionHelper.shared.user?.currency.rawValue  ?? CurrencyModel.usd.rawValue
    }()

    var formattedPrice: String {
        return String.formatToCurrency(attachment.value, currencyCode: currency) ?? .empty
    }

    var dateFormatted: String {
        return attachment.date?.formatDateToCustomString(dateFormatString: Date.Format.monthAndYear) ?? "No date"
    }

    init(
        attachment: AttachmentDomainModel,
        deleteExpenseUseCase: DeleteExpenseUseCaseProtocol = DeleteExpenseUseCase(repository: AttachmentRepository()),
        dismiss: (()->Void)? = nil
    ) {
        self.attachment = attachment
        self.deleteExpenseUseCase = deleteExpenseUseCase
        self.dismiss = dismiss
        pdfViewModel = .init()
        if let url = attachment.attachmentURL {
            pdfViewModel.loadRemotePDF(from: url)
        }

        pdfViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func deleteExpense() {
        isLoading = true
        deleteExpenseUseCase.execute(id: attachment.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let err):
                    print("Failed to delete expense: \(err)")
                    // Possibly show an alert
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                // On success, remove from local attachments
                guard let self = self else { return }
                self.dismiss?()
            }
            .store(in: &cancellable)
    }
}


extension AttachmentDetailViewModel {
    enum Navigation: String {
        case editAttachment
    }
}
