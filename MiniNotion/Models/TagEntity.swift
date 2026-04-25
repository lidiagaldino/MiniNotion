//
//  TagEntity.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftData
import Foundation

@Model
final class TagEntity {
    
    var id: UUID
    var name: String
    
    @Relationship(inverse: \NoteEntity.tags)
    var notes: [NoteEntity] = []
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}


extension TagEntity {
    
    func toDomain() -> Tag {
        Tag(id: id, name: name)
    }
}
