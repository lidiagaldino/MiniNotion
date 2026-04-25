//
//  NoteRowView.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftUI

struct NoteRowView: View {
    
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                if note.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }
            
            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            if !note.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(note.tags) { tag in
                            TagChip(title: tag.name, isSelected: false)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
