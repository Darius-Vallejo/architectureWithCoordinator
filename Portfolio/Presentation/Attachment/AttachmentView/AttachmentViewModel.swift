//
//  AttachmentViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 16/01/25.
//

import SwiftUI
import Combine

class AttachmentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isShowingNewAssetMenu = false
    @Published var attachments: [AttachmentDomainModel] = []
    @Published var buttonPosition: CGPoint = .zero
    @Published var attachmentToPresent: AttachmentDomainModel?
    @Published var isFromExpenses: Bool
    @Published var attachmentToConfirm: AttachmentDomainModel?
    @Published var customMenuItems: [CustomMenuItem] = []
    var cancellable = Set<AnyCancellable>()
    private let assetId: Int

    let fetchAttachmentsUseCase: FetchAttachmentsUseCaseProtocol
    let deleteExpenseUseCase: DeleteExpenseUseCaseProtocol

    init(
        assetId: Int,
        fetchAttachmentsUseCase: FetchAttachmentsUseCaseProtocol = FetchAttachmentsUseCase(repository: AttachmentRepository()),
        deleteExpenseUseCase: DeleteExpenseUseCaseProtocol = DeleteExpenseUseCase(repository: AttachmentRepository()),
        attachments: [AttachmentDomainModel] = [],
        isFromExpenses: Bool = false
    ) {
        self.fetchAttachmentsUseCase = fetchAttachmentsUseCase
        self.attachments = attachments
        self.assetId = assetId
        self.isFromExpenses = isFromExpenses
        self.deleteExpenseUseCase = deleteExpenseUseCase
    }

    func loadListOfAttachments() {
        isLoading = true

        fetchAttachmentsUseCase.execute(assetId: assetId,
                                        findAllExpenses: !isFromExpenses)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
        } receiveValue: { [weak self] attachments in
            self?.attachments = attachments
        }
        .store(in: &cancellable)
    }

    func onTapOnItem(attachment: AttachmentDomainModel) {
        if isFromExpenses {
            attachmentToConfirm = attachment
        } else {
            attachmentToPresent = attachment
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
