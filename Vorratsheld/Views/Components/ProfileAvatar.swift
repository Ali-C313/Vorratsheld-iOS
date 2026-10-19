//
//  ProfileAvatar.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Ohne Foto die Initialen, ohne Namen ein Icon
struct ProfileAvatar: View {
    let photoBase64: String?
    let name: String
    var size: CGFloat = 64

    var body: some View {
        ZStack {
            Circle().fill(AppColor.primaryContainer)

            if let image = photo {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if !initials.isEmpty {
                Text(initials)
                    .font(.system(size: size * 0.38, weight: .semibold))
                    .foregroundStyle(AppColor.onPrimaryContainer)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.45))
                    .foregroundStyle(AppColor.onPrimaryContainer)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var photo: UIImage? {
        guard let photoBase64, let data = Data(base64Encoded: photoBase64) else { return nil }
        return UIImage(data: data)
    }

    private var initials: String {
        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map { String($0).uppercased() } }
            .joined()
    }
}

#Preview {
    ProfileAvatar(photoBase64: nil, name: "Ali Chehab")
}
