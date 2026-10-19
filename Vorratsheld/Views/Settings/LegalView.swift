//
//  LegalView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct LegalView: View {
    let type: LegalType

    var body: some View {
        ScrollView {
            Text(type.text)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .textSelection(.enabled)
        }
        .navigationTitle(type.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LegalView(type: .imprint)
    }
}
