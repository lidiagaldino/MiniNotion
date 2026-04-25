//
//  NoteEntity.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import SwiftData
import Foundation

@Model
final class NoteEntity {
    
    var id: UUID
    var title: String
    var content: String
    
    @Relationship
        var tags: [TagEntity] = []
    
    var createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool = false
    
    
    init(
            id: UUID,
            title: String,
            content: String,
            isFavorite: Bool,
            tags: [TagEntity],
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.title = title
            self.content = content
            self.isFavorite = isFavorite
            self.tags = tags
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
}


extension NoteEntity {
    
    func toDomain() -> Note {
        Note(
            id: id,
            title: title,
            content: content,
            tags: tags.map { $0.toDomain() },
            isFavorite: isFavorite,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
