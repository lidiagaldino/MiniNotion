import SwiftUI

struct NoteEditorView: View {
    
    @ObservedObject var viewModel: NotesViewModel
    
    @State private var note: Note
    @State private var newTagText: String = ""
    
    
    init(note: Note, viewModel: NotesViewModel) {
        self._note = State(initialValue: note)
        self.viewModel = viewModel
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
                        TagChip(title: tag.name, isSelected: true)
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
            
            Spacer()
        }
        .padding()
        .navigationTitle("Editar Nota")
        .toolbar {
            Button("Salvar") {
                save()
            }
        }
    }
}

private extension NoteEditorView {
    
    func addTag() {
        let trimmed = newTagText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else { return }
        
        if note.tags.contains(where: { $0.name.lowercased() == trimmed.lowercased() }) {
            newTagText = ""
            return
        }
        
        let tag = Tag(
            id: UUID(),
            name: trimmed
        )
        
        note.tags.append(tag)
        
        newTagText = ""
    }
}

private extension NoteEditorView {
    
    func save() {
        note.updatedAt = Date()
        viewModel.update(note: note)
    }
}
