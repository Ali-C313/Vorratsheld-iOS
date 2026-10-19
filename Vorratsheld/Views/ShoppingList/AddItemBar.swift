//
//  AddItemBar.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct AddItemBar: View {
    let onAddItem: (String) -> Void

    @State private var text = ""

    var body: some View {
        HStack(spacing: 10) {
            TextField(S.shoppingAddHint, text: $text)
                .textInputAutocapitalization(.sentences)
                .submitLabel(.done)
                .onSubmit(submit)
                .padding(.horizontal, 14)
                .frame(height: 50)
                .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.outlineVariant))

            Button(action: submit) {
                Image(systemName: "plus")
                    .font(.title3.bold())
                    .foregroundStyle(AppColor.onPrimary)
                    .frame(width: 52, height: 52)
                    .background(AppColor.primary.opacity(text.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1), in: Circle())
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
            .accessibilityLabel(S.actionAdd)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.bar)
    }

    private func submit() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        onAddItem(text)
        text = ""
    }
}
