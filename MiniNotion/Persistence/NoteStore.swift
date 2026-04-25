//
//  NoteStore.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

protocol NoteStore {
    func fetch() throws -> [Note]
    //func fetchNotes(filteredBy tag: Tag?) throws -> [Note]
    func save(_ note: Note) throws
    func delete(_ note: Note) throws
}
