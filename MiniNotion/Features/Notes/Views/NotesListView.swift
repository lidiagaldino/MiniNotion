//
//  NotesListView.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftUI

struct NotesListView: View {
    
    @StateObject private var viewModel: NotesViewModel
    
    init(viewModel: NotesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                TagFilterView(
                    tags: viewModel.tags,
                    selectedTag: viewModel.selectedTag,
                    onSelect: viewModel.selectTag
                )
                
                List {
                    ForEach(viewModel.notes) { note in
                        NavigationLink {
                            NoteEditorView(note: note, viewModel: viewModel)
                        } label: {
                            NoteRowView(note: note)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Notas")
            .searchable(text: $viewModel.searchText)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.showFavoritesOnly.toggle()
                    } label: {
                        Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.createNote()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}
