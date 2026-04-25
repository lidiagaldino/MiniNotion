import Foundation
import Combine

@MainActor
final class NotesViewModel: ObservableObject {
    
    
    @Published private(set) var notes: [Note] = []
    @Published private(set) var tags: [Tag] = []
    @Published var showFavoritesOnly: Bool = false

    private var allNotes: [Note] = []
    
    @Published var searchText: String = ""
    @Published var selectedTag: Tag?
    
    
    private let store: NoteStore
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(store: NoteStore) {
        self.store = store
        
        setupBindings()
        loadInitialData()
    }
}


private extension NotesViewModel {
    
    func setupBindings() {
        
        Publishers.CombineLatest3($searchText, $selectedTag, $showFavoritesOnly)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] (searchText, selectedTag, showFavoritesOnly) in
                self?.applyFilters(
                    searchText: searchText,
                    tag: selectedTag,
                    favoritesOnly: showFavoritesOnly
                )
            }
            .store(in: &cancellables)
    }
    
    func loadInitialData() {
        do {
            let all = try store.fetch()
            self.allNotes = all
            self.tags = extractTags(from: all)
            
            applyFilters(
                searchText: searchText,
                tag: selectedTag,
                favoritesOnly: showFavoritesOnly
            )
        } catch {
            print(error)
        }
    }
}


private extension NotesViewModel {
    
    func applyFilters(searchText: String, tag: Tag?, favoritesOnly: Bool) {
        
        var filtered = allNotes
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let tag {
            filtered = filtered.filter {
                $0.tags.contains { $0.name == tag.name }
            }
        }
        
        if favoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        self.notes = filtered
    }
    
    func extractTags(from notes: [Note]) -> [Tag] {
        let allTags = notes.flatMap { $0.tags }
        return Array(Set(allTags)).sorted { $0.name < $1.name }
    }
}

extension NotesViewModel {
    
    func selectTag(_ tag: Tag?) {
        selectedTag = tag
    }
    
    func createNote() {
        let newNote = Note(
            id: UUID(),
            title: "Nova nota",
            content: "",
            tags: [],
            isFavorite: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        do {
            try store.save(newNote)
            reload()
        } catch {
            print("Erro ao criar nota:", error)
        }
    }
    
    func update(note: Note) {
        do {
            try store.save(note)
            reload()
        } catch {
            print("Erro ao atualizar nota:", error)
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let note = notes[index]
            try? store.delete(note)
        }
        reload()
    }
    
    func toggleTag(_ tag: Tag, for note: Note) {
        var updated = note
        
        if updated.tags.contains(tag) {
            updated.tags.removeAll { $0 == tag }
        } else {
            updated.tags.append(tag)
        }
        
        update(note: updated)
    }
}


private extension NotesViewModel {
    
    func reload() {
        do {
            let all = try store.fetch()
            self.allNotes = all
            self.tags = extractTags(from: all)
            
            applyFilters(
                searchText: searchText,
                tag: selectedTag,
                favoritesOnly: showFavoritesOnly
            )
        } catch {
            print(error)
        }
    }
}
