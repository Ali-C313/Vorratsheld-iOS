//
//  HelpView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct HelpView: View {

    @State var supportViewModel: SupportViewModel

    @State private var snackbar: SnackbarMessage?

    var body: some View {
        Form {
            if supportViewModel.isSent {
                Section {
                    Label(S.helpSent, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(AppColor.onPrimaryContainer)
                        .listRowBackground(AppColor.primaryContainer)
                }
            }

            Section {
                Text(S.helpIntro)
                    .font(.subheadline)
                    .foregroundStyle(AppColor.onSurfaceVariant)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
            }

            Section {
                Picker(S.helpCategory, selection: $supportViewModel.category) {
                    ForEach(SupportCategory.allCases) { category in
                        Text(category.label).tag(category)
                    }
                }
                TextField(S.helpSubject, text: $supportViewModel.subject)
                TextField(S.helpMessage, text: $supportViewModel.message, axis: .vertical)
                    .lineLimit(6...12)
                TextField(S.helpReplyEmail, text: $supportViewModel.replyEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section {
                Button {
                    supportViewModel.send()
                } label: {
                    HStack {
                        Spacer()
                        if supportViewModel.isSending {
                            ProgressView()
                        } else {
                            Text(S.helpSend)
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(supportViewModel.isSending)
            }
        }
        .navigationTitle(S.helpTitle)
        .navigationBarTitleDisplayMode(.inline)
        .snackbar($snackbar)
        .onChange(of: supportViewModel.errorMessage) { _, errorMessage in
            if let errorMessage {
                snackbar = SnackbarMessage(text: errorMessage)
                supportViewModel.errorMessage = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        HelpView(supportViewModel: PreviewData.supportViewModel)
    }
}
