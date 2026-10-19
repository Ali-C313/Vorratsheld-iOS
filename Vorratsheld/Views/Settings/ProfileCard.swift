//
//  ProfileCard.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ProfileCard: View {

    let user: FireUser?
    let email: String
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 16) {
                ProfileAvatar(photoBase64: user?.photoBase64, name: user?.fullName ?? "")
                VStack(alignment: .leading, spacing: 2) {
                    Text((user?.fullName ?? "").isEmpty ? S.settingsProfileIncomplete : user?.fullName ?? "")
                        .font(.headline)
                        .foregroundStyle(AppColor.onSurface)
                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                }
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppColor.outline)
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    List {
        ProfileCard(user: FireUser(firstName: "Ali", lastName: "Chehab"), email: "ali@example.com") {}
    }
}
