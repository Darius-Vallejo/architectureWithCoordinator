//
//  String+Localization.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 13/11/24.
//

import Foundation

extension String {
    enum Localized: String {
        case appleIdLogin
        case gmailLogin
        case welcomeBack
        case welcomeBackDetail
        case noContentYet
        case settingsTitle
        case changeUsername
        case changeProfilePicture
        case changeDescription
        case makeYourAccountPrivate
        case makeYourAssetPrivate
        case save
        case next
        case chooseFromLibrary
        case takePhoto
        case retake
        case usePhoto
        case selectImage
        case done
        case viewMoreImages
        case takeImages
        case cancel
        case cameraAccessIsRequired
        case uploadImages
        case takeNewImages
        case select
        case onboardingNewAssetDescription
        case onboardingNewAssetTitle
        case logout
        case changeCurrency
        case didYouLikeIt
        case profile
        case search
        case feed
        case invest
        case price
        case status
        case costPerMonth
        case title
        case descriptionOptional
        case dateOfPurchase
        case dateOfConstruction
        case addNewCar
        case selectDate
        case date
        case makeField
        case modelField
        case VIN
        case mileage
        case tagForMarket
        case rent
        case sell
        case offMarket
        case clean
        case privateTitle
        case publicTitle
        case assetValue
        case close
        case addNewRV
        case addNewLot
        case addNewAircraft
        case addNewHouse
        case addNewBoat
        case areaMt2
        case tailNumber
        case hoursFlown
        case HIN
        case length
        case residential
        case commercial
        case zoningInformation
        case lot
        case car
        case house
        case boat
        case aircraft
        case rv
        case library
        case reset
        case attachment
        case expenseHistory
        case attachmentTitle
        case attachmentDescription
        case newAttachmentTitle
        case newAttachmentDescription
        case expenses
        case month
        case filter
        case file
        case addNewDocument
        case expenseValue
    }

    static func localized(_ localized: Localized) -> String {
        return String(localized: LocalizationValue(localized.rawValue))
    }
}


