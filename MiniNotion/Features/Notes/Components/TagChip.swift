//
//  TagChip.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftUI

struct TagChip: View {
    
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color(.systemGray5))
            )
            .foregroundStyle(isSelected ? .white : .primary)
    }
}
