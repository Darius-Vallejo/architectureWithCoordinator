//
//  DropdownViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/12/24.
//

import SwiftUI
import Combine

struct DropdownItem: Identifiable, Hashable {
    let id: String
    let value: String
    let index: Int
}

class DropdownViewModel: ObservableObject, FormComponent {
            
    enum State: Hashable {
        case loading
        case success(items: [DropdownItem])
        case failure(error: String)
    }
    
    typealias DropdownDataProvider = () async throws -> [DropdownItem]
    typealias DropdownSelectedItemHandler = (_ value: DropdownItem) -> Void
    
    @Published var inputError: String?
    @Published var isExpanded: Bool = false
    @Published var state: State
    @Published var enableDefaultValue: String?
    @Published var data: DropdownItem {
        didSet {
            if isOptionSelected {
                selectedItemHandler?(data)
            }
            
            validate(newValue: data)
        }
    }
    
    var componentText: String {
        !data.value.isEmpty ? data.value : placeholder
    }
    
    var isOptionSelected: Bool {
        !data.value.isEmpty
    }
    
    var isComponentReadySubject: CurrentValueSubject<Bool, Never>
    var selectedItemHandler: DropdownSelectedItemHandler?
    let validator: any FormDataValidator<DropdownItem>
    let componentName: String
    private let placeholder: String
    private let dataProvider: DropdownDataProvider
    
    init(placeholder: String,
         componentName: String,
         validator: any FormDataValidator<DropdownItem> = DefaultFormDropdownInputValidator(),
         dataProvider: @escaping DropdownDataProvider
    ) {
        state = .loading
        data = .init(id: "", value: "", index: -1)
        isComponentReadySubject = .init(false)
        self.componentName = componentName
        self.validator = validator
        self.placeholder = placeholder
        self.dataProvider = dataProvider
        //validate(newValue: data)
    }
    
    func viewDidLoad() async {
        await callOnMainThread { [weak self] in self?.state = .loading }
        
        do {
            let items = try await dataProvider()
            
            await callOnMainThread { [weak self] in
                self?.state = .success(items: items)
                if let defaultValue = self?.enableDefaultValue {
                    self?.setValue(by: defaultValue, items: items)
                }
            }
        } catch {
            print("Error fetching car brands: \(error)")
            
            await callOnMainThread { [weak self] in
                self?.state = .failure(error: "We could not load items.")
            }
        }
    }
    
    func retry() async {
        await viewDidLoad()
    }
    
    private func callOnMainThread(_ block: @escaping () -> Void) async {
        await MainActor.run { block() }
    }

    private func setValue(by key: String, items: [DropdownItem]) {
        if let selectedItem = items.first(where: { item in
            return item.id == key
        }) {
            data = selectedItem
        }
    }

    func setDefaultValue(value: String) {
        if case .success(let items) = state {
            setValue(by: value, items: items)
        } else if case .loading = state {
            enableDefaultValue = value
        }
    }
}
