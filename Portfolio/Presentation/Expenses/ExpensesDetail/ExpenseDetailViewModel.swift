//
//  ExpenseDetailViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 7/01/25.
//

import SwiftUI
import Combine

class ExpenseDetailViewModel: ObservableObject {
    @Published var expense: Expense
    @Published var assetId: Int
    @Published var newExpesesViewModel: CreateNewExpenseViewModel
    @Published var attachmentDetailViewModel: AttachmentDetailViewModel
    @Published var isLoading: Bool = false
    @Published var attachments: [AttachmentDomainModel] = []
    @Published var isShowingNewAssetMenu: Bool = false
    @Published var buttonPosition: CGPoint = .zero
    @Published var customMenuItems: [CustomMenuItem] = []
    @Published var selectedAttachment: AttachmentDomainModel?

    var cancellable = Set<AnyCancellable>()


    private let fetchAttachmentsUseCase: FetchAttachmentsFromDateUseCaseProtocol
    private let deleteExpenseUseCase: DeleteExpenseUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(expense: Expense,
         assetId: Int,
         attachments: [AttachmentDomainModel] = [],
         deleteExpenseUseCase: DeleteExpenseUseCaseProtocol = DeleteExpenseUseCase(repository: AttachmentRepository()),
         fetchAttachmentsUseCase: FetchAttachmentsFromDateUseCaseProtocol = FetchAttachmentsFromDateUseCase(repository: AttachmentRepository())) {
        self.expense = expense
        self.assetId = assetId
        self.newExpesesViewModel = .init(assetId: assetId, date: expense.date)
        self.fetchAttachmentsUseCase = fetchAttachmentsUseCase
        self.attachments = attachments
        self.deleteExpenseUseCase = deleteExpenseUseCase
        self.attachmentDetailViewModel = .init(attachment: .init(id: 0,
                                                                 name: "",
                                                                 value: 0,
                                                                 date: nil,
                                                                 description: nil,
                                                                 type: .appraisal,
                                                                 isCreatedAsAttachment: true,
                                                                 attachmentURL: nil,
                                                                 attachmentId: 0))
    }

    func loadAttachments() {
        let date: Date = expense.date
        isLoading = true
        fetchAttachmentsUseCase.execute(date: date, assetId: assetId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.attachments = []
                    print(error)
                }
            } receiveValue: { [weak self] attachments in
                self?.attachments = attachments
            }
            .store(in: &cancellables)
    }

    func setupExpenseWithResult(_ result: NewAttachmentForExpenseViewModel.SavingResult) {
        switch result {
        case .fromExistingAttachment(let attachmentId, let remoteUrl):
            self.newExpesesViewModel.attachmentAssociatedId = attachmentId
            self.newExpesesViewModel.remoteUrl = remoteUrl
        case .fromNewAttachment(let localPdfUrl):
            self.newExpesesViewModel.pdfUrl = localPdfUrl
        }
    }

    func deleteExpense(attachment: AttachmentDomainModel) {
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
                self.attachments.removeAll(where: { $0.id == attachment.id })
            }
            .store(in: &cancellable)
    }
}

extension ExpenseDetailViewModel {
    enum Navigation: String {
        case attachmentSelect
        case createNewExpense
        case detailOfAttachment
        case updateAttachment
    }
}
