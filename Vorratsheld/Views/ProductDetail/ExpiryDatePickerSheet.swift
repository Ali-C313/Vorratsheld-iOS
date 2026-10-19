//
//  ExpiryDatePickerSheet.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ExpiryDatePickerSheet: View {
    let expiryDate: Int64
    let onApply: (Int64) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selection = Date()

    var body: some View {
        NavigationStack {
            DatePicker(S.productExpiry, selection: $selection, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(S.actionCancel) { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(S.actionApply) {
                            onApply(LocalDay(localDate: selection).millis)
                            dismiss()
                        }
                    }
                }
        }
        .presentationDetents([.medium, .large])
        .onAppear {
            selection = DateHelper.expiryDateToLocalDay(expiryDate).localDate
        }
    }
}
