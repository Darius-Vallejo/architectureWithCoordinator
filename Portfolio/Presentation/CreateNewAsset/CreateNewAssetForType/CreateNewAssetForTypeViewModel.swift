//
//  CreateNewAssetForTypeViewModel.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 15/12/24.
//

import Combine
import Foundation

class CreateNewAssetForTypeViewModel: ObservableObject {
    var assetType: AssetType
    @Published var selectedImages: [RecentImage] = []
    @Published var isPrivate: Bool = false
    @Published var priceViewModel: CustomTextFieldViewModel
    @Published var titleViewModel: CustomTextFieldViewModel
    @Published var descriptionViewModel: CustomTextFieldViewModel
    @Published var costPerMonthViewModel: CustomTextFieldViewModel
    @Published var dateOfPurchase: Date = .now
    @Published var dateOfConstruction: Date = .now
    @Published var VINViewModel: CustomTextFieldViewModel
    @Published var mileageViewModel: CustomTextFieldViewModel
    @Published var areaViewModel: CustomTextFieldViewModel
    @Published var makeViewModel: CustomTextFieldViewModel
    @Published var modelViewModel: CustomTextFieldViewModel

    // MARK: Dropdown Variables
    @Published var carBrandViewModel: DropdownViewModel
    @Published var carModelViewModel: DropdownViewModel?
    @Published var marketTagViewModel: DropdownViewModel
    @Published var zoningViewModel: DropdownViewModel

    // MARK: Form Result Variables
    var savingAssetMessage: String {
        return "Saving your \(assetType.text)..."
    }
    @Published var isSavingAsset: Bool = false
    @Published var isButtonEnabled: Bool = false
    @Published var showErrorAlert: Bool = false

    @Published var focusedField: String?
    var formError: String = ""
    var saveAssetsUseCase: SaveAssetsUseCaseProtocol

    private let fetchAssetsUseCase: FetchAssetsUseCaseProtocol
    private let didCreateAssetSuccessfully: DidCreateAssetSuccessfully?
    private var subscriptions: Set<AnyCancellable> = []
    private var viewDidLoad = false
    private var fieldsToValidate: [(String, AnyPublisher<Bool, Never>)] {
        switch assetType {
        case .car, .RV:
            return [
                ("Title", titleViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Asset Value", priceViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Make", carBrandViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Market Tag", marketTagViewModel.isComponentReadySubject.eraseToAnyPublisher())
            ]
        case .lot:
            return [
                ("Title", titleViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Asset Value", priceViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Zoning", zoningViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Market Tag", marketTagViewModel.isComponentReadySubject.eraseToAnyPublisher())
            ]
        case .house:
            return [
                ("Title", titleViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Asset Value", priceViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Market Tag", marketTagViewModel.isComponentReadySubject.eraseToAnyPublisher())
            ]
        case .aircraft, .boat:
            return [
                ("Title", titleViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Asset Value", priceViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Make", makeViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Model", modelViewModel.isComponentReadySubject.eraseToAnyPublisher()),
                ("Market Tag", marketTagViewModel.isComponentReadySubject.eraseToAnyPublisher())
            ]
        }
    }

    private var formAsset: AssetDomainModel {
        AssetDomainModel(
            id: 1,
            type: assetType,
            price: Double(priceViewModel.data) ?? .zero,
            isPrivate: isPrivate,
            costsPerMonth: Double(costPerMonthViewModel.data) ?? .zero,
            title: titleViewModel.data,
            description: descriptionViewModel.data,
            dateOfPurchase: dateOfPurchase,
            imagesURL: [],
            imagesContent: selectedImages.compactMap { $0.compressThumbnailImage() },
            tag: TagForMarket(rawValue: marketTagViewModel.data.id) ?? .offMarket,
            assetDetails: assetDetails
        )
    }

    private var assetDetails: AssetDetails {
        switch assetType {
        case .car, .RV:
                .init(
                    make: carBrandViewModel.data.value,
                    model: carModelViewModel?.data.value ?? "",
                    vin: VINViewModel.data,
                    mileage: Int(mileageViewModel.data),
                    zoning: ZoningInformation(rawValue: zoningViewModel.data.value) ?? .residential
                )
        case .house:
                .init(
                    dateOfConstruction: dateOfConstruction,
                    area: Double(areaViewModel.data)
                )
        case .aircraft:
                .init(
                    make: makeViewModel.data,
                    model: modelViewModel.data,
                    vin: VINViewModel.data,
                    mileage: Int(mileageViewModel.data)
                )
        case .boat:
                .init(
                    make: makeViewModel.data,
                    model: modelViewModel.data,
                    dateOfConstruction: dateOfConstruction,
                    area: Double(areaViewModel.data)
                )
        case .lot:
                .init(
                    area: Double(areaViewModel.data),
                    zoning: ZoningInformation(rawValue: zoningViewModel.data.value) ?? .residential
                )
        }
    }

    init(
        assetType: AssetType,
        recentImages: [RecentImage],
        fetchAssetsUseCase: FetchAssetsUseCaseProtocol? = nil,
        saveAssetsUseCase: SaveAssetsUseCaseProtocol? = nil,
        didCreateAssetSuccessfully: DidCreateAssetSuccessfully? = nil
    ) {
        self.assetType = assetType
        self.selectedImages = recentImages
        self.didCreateAssetSuccessfully = didCreateAssetSuccessfully
        self.saveAssetsUseCase = saveAssetsUseCase ?? SaveAssetsUseCase(repository: CarAssetRepository())
        let fetchAssetsUseCase = fetchAssetsUseCase ?? FetchAssetsUseCase(repository: CarAssetRepository())
        self.fetchAssetsUseCase = fetchAssetsUseCase

        priceViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.assetValue),
            componentName: "Price",
            validator: DefaultFormInputTextValidator(inputForm: .decimal)
        )
        
        titleViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.title),
            componentName: "Title",
            validator: DefaultFormInputTextValidator()
        )
        
        descriptionViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.descriptionOptional),
            componentName: "Description",
            validator: EmptyFormInputTextValidator()
        )
        
        costPerMonthViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.costPerMonth),
            componentName: "Cost Per Month",
            validator: EmptyFormInputTextValidator()
        )

        areaViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.areaMt2),
            componentName: "Mileage",
            validator: DefaultFormInputTextValidator(inputForm: .decimal)
        )

        makeViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.makeField),
            componentName: "Make",
            validator: DefaultFormInputTextValidator(inputForm: .text)
        )

        modelViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.modelField),
            componentName: "Model",
            validator: DefaultFormInputTextValidator(inputForm: .text)
        )

        zoningViewModel = DropdownViewModel(
            placeholder: String.localized(.zoningInformation),
            componentName: "Zoning",
            dataProvider: {
                ZoningInformation.allCases.enumerated().map { (index, item) in
                    DropdownItem.init(id: ZoningInformation.allCases[index].rawValue, value: item.rawValue, index: index)
                }
            }
        )

        mileageViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.length),
            componentName: "Length",
            validator: DefaultFormInputTextValidator(inputForm: .decimal)
        )

        carBrandViewModel = DropdownViewModel(
            placeholder: String.localized(.makeField),
            componentName: "Make",
            validator: EmptyFormDropdownInputValidator(),
            dataProvider: {
                try await fetchAssetsUseCase.getCarBrands().enumerated().map { (index, item) in
                    DropdownItem.init(id: item.id, value: item.name, index: index)
                }
            }
        )

        marketTagViewModel = DropdownViewModel(
            placeholder: String.localized(.tagForMarket),
            componentName: "Tag for Market",
            dataProvider: {
                CreateNewAssetForTypeConstants.StaticOptions.marketTags.enumerated().map { (index, item) in
                    DropdownItem.init(id: TagForMarket.allCases[index].rawValue, value: item, index: index)
                }
            }
        )

        VINViewModel = CustomTextFieldViewModel(
            data: "",
            placeholder: String.localized(.VIN),
            componentName: "VIN",
            validator: DefaultFormInputTextValidator()
        )


        if case .boat = assetType {
            VINViewModel = CustomTextFieldViewModel(
                data: "",
                placeholder: String.localized(.HIN),
                componentName: "Hin",
                validator: DefaultFormInputTextValidator()
            )
        } else if case .aircraft = assetType {
            VINViewModel = CustomTextFieldViewModel(
                data: "",
                placeholder: String.localized(.tailNumber),
                componentName: "Tail",
                validator: DefaultFormInputTextValidator()
            )
        }
    }


    func viewDidLoad() async {
        guard !viewDidLoad else { return }

        carBrandViewModel.selectedItemHandler = { [weak self] value in
            self?.handleNewCarBrand(with: value)
        }


        Publishers.CombineLatest(
            $isPrivate.removeDuplicates(),
            priceViewModel.isComponentReadySubject.removeDuplicates()
        )
        .combineLatest(validationPipeline)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] combinedResult in
            let ((isPrivate, isPriceValid), fieldsResult) = combinedResult
            self?.enableSaveButtonIfNeeded(from: (fieldsResult, isPrivate, isPriceValid))
        }
        .store(in: &subscriptions)

        viewDidLoad = true
    }
    private var validationPipeline: AnyPublisher<[(String, Bool)], Never> {
        // Map each field's validation publisher to an identifiable result
        let publishers = fieldsToValidate.map { field in
            field.1
                .removeDuplicates()
                .map { isValid in (field.0, isValid) } // Pair field name with its validity
                .eraseToAnyPublisher()
        }

        // Combine all publishers dynamically and emit updates as they occur
        return Publishers.MergeMany(publishers)
            .scan([]) { partialResult, newField in
                var result = partialResult.filter { $0.0 != newField.0 } // Remove duplicates by field name
                result.append(newField) // Add or update the field
                return result
            }
            .eraseToAnyPublisher()
    }

    func saveAsset() {
        Task {
            if let inputError = await getInputErrorBeforeSaving() {
                self.formError = inputError
                showErrorAlert = true
                return
            }

            await saveAssetAfterValidation()
        }
    }
    
    private func getInputErrorBeforeSaving() async -> String? {
        // An array to collect error messages
        var inputErrors: [String] = []

        // Dynamically validate fields using AsyncPublisher
        for field in fieldsToValidate {
            let isValid = await field.1.values.first(where: { _ in true }) ?? false
            if !isValid {
                inputErrors.append("\(field.0) is required.")
            }
        }

        // Include Market Tag validation if the asset is not private
        if !isPrivate, let marketTagError = marketTagViewModel.inputError {
            inputErrors.append(marketTagError)
        }

        return inputErrors.first // Return the first error, or nil if all are valid
    }

    private func saveAssetAfterValidation() async {
        await MainActor.run {
            isSavingAsset = true
        }

        do {
            try await saveAssetsUseCase.save(formAsset)

            await MainActor.run {
                isSavingAsset = false
                didCreateAssetSuccessfully?(assetType)
            }
        } catch {
            await MainActor.run {
                isSavingAsset = false
                formError = if let networkError = error as? NetworkError {
                    "We could not save your asset, there is an error: \(networkError)"
                } else {
                    error.localizedDescription
                }
                showErrorAlert = true
            }
        }
    }

    private func enableSaveButtonIfNeeded(from result: ([(String, Bool)], Bool, Bool)) {
        let (fieldsResult, isPrivate, isPriceValid) = result
        let realIsMarketValid = !isPrivate ? fieldsResult.first(where: { $0.0 == "Market Tag" })?.1 ?? false : true

        let areFieldsValid = fieldsResult.allSatisfy { $0.1 }

        isButtonEnabled = areFieldsValid && realIsMarketValid && isPriceValid
    }

    // MARK: Dropdown methods
    private func handleNewCarBrand(with item: DropdownItem) {
        setupCarModelDropdown(with: item)
    }
    
    private func setupCarModelDropdown(with carBrand: DropdownItem) {
        let carModelViewModel = DropdownViewModel(
            placeholder: String.localized(.modelField),
            componentName: "Model",
            validator: EmptyFormDropdownInputValidator(),
            dataProvider: { [weak self] in
                try await self?.fetchAssetsUseCase.getCarModels(for: CarBrandDetail(
                    id: carBrand.id,
                    name: carBrand.value
                ))
                .enumerated().map { (index, item) in
                    DropdownItem(id: String(item.id), value: item.name, index: index)
                } ?? []
            }
        )
        
        self.carModelViewModel = carModelViewModel
    }
}
