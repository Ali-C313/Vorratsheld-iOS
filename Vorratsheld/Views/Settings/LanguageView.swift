//
//  LanguageView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct LanguageView: View {

    @Environment(AppViewModel.self) private var appViewModel

    var body: some View {
        List {
            Section {
                languageRow(S.languageSystem, code: nil)
            }
            Section {
                ForEach(AppLanguage.allCases) { language in
                    languageRow(language.nativeName, code: language.code)
                }
            }
        }
        .navigationTitle(S.languageTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func languageRow(_ name: String, code: String?) -> some View {
        Button {
            appViewModel.setLanguage(code)
        } label: {
            HStack {
                Text(name)
                    .foregroundStyle(AppColor.onSurface)
                Spacer()
                if appViewModel.languageCode == code {
                    Image(systemName: "checkmark")
                        .foregroundStyle(AppColor.primary)
                        .fontWeight(.semibold)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        LanguageView()
    }
    .environment(AppViewModel())
}
