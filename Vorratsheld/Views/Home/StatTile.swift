//
//  StatTile.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct StatTile: View {
    let label: String
    let count: Int
    let background: Color
    let content: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(count)")
                .font(.title2.weight(.heavy))
                .contentTransition(.numericText(value: Double(count)))
                .animation(.easeOut(duration: 0.8), value: count)
            Text(label)
                .font(.caption.weight(.medium))
                .lineLimit(1)
        }
        .foregroundStyle(content)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(background, in: RoundedRectangle(cornerRadius: 18))
    }
}
