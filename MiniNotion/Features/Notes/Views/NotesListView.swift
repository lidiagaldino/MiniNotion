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
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                delete(note)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Notas")
            .searchable(text: $viewModel.searchText)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Mais recentes") {
                            viewModel.sortOption = .newestFirst
                        }
                        
                        Button("Mais antigas") {
                            viewModel.sortOption = .oldestFirst
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
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


private extension NotesListView {
    private func delete(_ note: Note) {
        if let index = viewModel.notes.firstIndex(where: { $0.id == note.id }) {
            viewModel.delete(at: IndexSet(integer: index))
        }
    }
}
