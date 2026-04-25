//
//  TagFilterView.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftUI

struct TagFilterView: View {
    
    let tags: [Tag]
    let selectedTag: Tag?
    let onSelect: (Tag?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                
                Button {
                    onSelect(nil)
                } label: {
                    TagChip(title: "Todos", isSelected: selectedTag == nil)
                }
                
                ForEach(tags) { tag in
                    Button {
                        onSelect(tag)
                    } label: {
                        TagChip(
                            title: tag.name,
                            isSelected: selectedTag?.name == tag.name
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
    }
}
