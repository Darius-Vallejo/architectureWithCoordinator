//
//  DateSelectionView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 15/12/24.
//


import SwiftUI

struct DateSelectionView: View {
    @Binding var selectedDate: Date
    @Binding var focusedField: String?
    var focusID: String = "" // Unique ID for this view
    @Binding var isAlreadyEdited: Bool
    @State private var showDatePicker: Bool = false {
        didSet {
            if !isAlreadyEdited {
                isAlreadyEdited = true
            }
            if showDatePicker {
                focusedField = focusID
            }
        }
    }
    var title: String
    // The user can only pick dates in [minimumDate, maximumDate].
    var minimumDate: Date?
    var maximumDate: Date?

    init(selectedDate: Binding<Date>,
         focusedField: Binding<String?> = .constant(nil),
         focusID: String = "",
         isAlreadyEdited: Binding<Bool> = .constant(false),
         showDatePicker: Bool  = false,
         title: String,
         minimumDate: Date? = nil,
         maximumDate: Date? = nil) {
        self._selectedDate = selectedDate
        self._focusedField = focusedField
        self.focusID = focusID
        self._isAlreadyEdited = isAlreadyEdited
        self.showDatePicker = showDatePicker
        self.title = title
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }


    var body: some View {
        VStack {
            Button(action: {
                hideKeyboard()
                showDatePicker.toggle()
            }) {
                HStack {
                    Text(isAlreadyEdited ? selectedDate.formatted(date: .complete, time: .omitted) : title)
                        .foregroundColor(isAlreadyEdited ? .blackPortfolio : .greyPortfolio)
                        .font(CustomTextFieldConstants.Fonts.textFieldFont)

                    Spacer()

                    Image("calendarIcon")
                }
                .padding(.horizontal, CustomTextFieldConstants.Dimensions.horizontalPadding)
                .padding(.vertical, CustomTextFieldConstants.Dimensions.verticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: CustomTextFieldConstants.Dimensions.cornerRadius)
                        .stroke(CustomTextFieldConstants.Colors.borderColor, lineWidth: CustomTextFieldConstants.Dimensions.borderLineWidth)
                )
            }
            .font(CustomTextFieldConstants.Fonts.textFieldFont)

            if showDatePicker {
                DatePicker(
                    String.localized(.selectDate),
                    selection: $selectedDate,
                    in: (minimumDate ?? Date.distantPast)...(maximumDate ?? Date.distantFuture),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                HStack {
                    Spacer()
                    Button("Done") {
                        showDatePicker.toggle()
                        clampSelectedDateIfNeeded()
                    }
                }
            }
        }
        .onChange(of: selectedDate) { _, _ in
            clampSelectedDateIfNeeded()
        }
    }

    /// Ensures the selectedDate remains within the specified range if present.
    private func clampSelectedDateIfNeeded() {
        if let minDate = minimumDate, selectedDate < minDate {
            selectedDate = minDate
        } else if let maxDate = maximumDate, selectedDate > maxDate {
            selectedDate = maxDate
        }
    }
}

#Preview {
    @Previewable @State var date: Date = .now
    @Previewable @State var field: String? = ""
    DateSelectionView(selectedDate: $date,
                      focusedField: $field,
                      focusID: "",
                      title: "Date of purchase",
                      minimumDate: .now,
                      maximumDate: .now
    )
}
