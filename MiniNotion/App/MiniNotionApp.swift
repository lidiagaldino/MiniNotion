//
//  MiniNotionApp.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 23/04/26.
//

import SwiftUI
import SwiftData

@main
struct MiniNotionApp: App {
    
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            NotesListView(
                viewModel: container.makeNotesViewModel()
            )
        }
        .modelContainer(container.modelContainer)
    }
}
