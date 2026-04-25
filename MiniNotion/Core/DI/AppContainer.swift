//
//  AppContainer.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftData

@MainActor
final class AppContainer {
    
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: NoteEntity.self)
        } catch {
            fatalError("Erro ao inicializar SwiftData: \(error)")
        }
    }
    
    
    func makeNoteStore() -> NoteStore {
        SwiftDataNoteStore(context: context)
    }
    
    
    func makeNotesViewModel() -> NotesViewModel {
        NotesViewModel(store: makeNoteStore())
    }
}
