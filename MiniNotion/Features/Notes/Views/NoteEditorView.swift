import SwiftUI

struct NoteEditorView: View {
    
    @ObservedObject var viewModel: NotesViewModel
    
    @State private var note: Note
    @State private var newTagText: String = ""
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    
    
    init(note: Note, viewModel: NotesViewModel) {
        self._note = State(initialValue: note)
        self.viewModel = viewModel
    }
    
    var suggestedTags: [Tag] {
        guard !newTagText.isEmpty else { return [] }
        
        return viewModel.tags
            .filter {
                $0.name.lowercased().contains(newTagText.lowercased())
            }
            .filter { suggested in
                !note.tags.contains { $0.name == suggested.name }
            }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            TextField("Título", text: $note.title)
                .font(.title)
            
            TextEditor(text: $note.content)
                .frame(minHeight: 150)
            
            Toggle("Favorito", isOn: $note.isFavorite)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(note.tags) { tag in
                        Button {
                            removeTag(tag)
                        } label: {
                            TagChip(title: tag.name, isSelected: true)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Adicionar tag...", text: $newTagText)
                    .textFieldStyle(.roundedBorder)
                
                Button("Adicionar") {
                    addTag()
                }
            }
            if !suggestedTags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(suggestedTags) { tag in
                                    Button {
                                        addExistingTag(tag)
                                    } label: {
                                        TagChip(title: tag.name, isSelected: false)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
            Spacer()
        }
        .padding()
        .navigationTitle("Editar Nota")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Salvar") {
                    save()
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("Excluir nota?", isPresented: $showDeleteAlert) {
            
            Button("Excluir", role: .destructive) {
                delete()
            }
            
            Button("Cancelar", role: .cancel) { }
            
        } message: {
            Text("Essa ação não pode ser desfeita.")
        }
    }
}

private extension NoteEditorView {
    
    func addTag() {
        let trimmed = newTagText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else { return }
        
        if let existing = viewModel.tags.first(where: {
            $0.name.lowercased() == trimmed.lowercased()
        }) {
            addExistingTag(existing)
            return
        }
        
        let tag = Tag(id: UUID(), name: trimmed)
        
        note.tags.append(tag)
        newTagText = ""
    }
    
    func removeTag(_ tag: Tag) {
        note.tags.removeAll { $0.id == tag.id }
    }
    
    func addExistingTag(_ tag: Tag) {
        note.tags.append(tag)
        newTagText = ""
    }
}

private extension NoteEditorView {
    
    func save() {
        note.updatedAt = Date()
        viewModel.update(note: note)
    }
    
    func delete() {
        viewModel.deleteNote(note)
        dismiss()
    }
    
}
