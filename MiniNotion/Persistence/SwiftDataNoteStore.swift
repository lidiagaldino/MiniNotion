import SwiftData
import Foundation

final class SwiftDataNoteStore: NoteStore {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
        
    func fetch() throws -> [Note] {
        let entities = try context.fetch(FetchDescriptor<NoteEntity>())
        return entities.map { $0.toDomain() }
    }
    
    
    func save(_ note: Note) throws {
        
        let existingTags = try context.fetch(FetchDescriptor<TagEntity>())
        
        let resolvedTags: [TagEntity] = note.tags.map { tag in
            if let existing = existingTags.first(where: { $0.name == tag.name }) {
                return existing
            } else {
                let newTag = TagEntity(name: tag.name)
                context.insert(newTag)
                return newTag
            }
        }
        
        let existingNotes = try context.fetch(FetchDescriptor<NoteEntity>())
        
        if let existing = existingNotes.first(where: { $0.id == note.id }) {
            
            existing.title = note.title
            existing.content = note.content
            existing.isFavorite = note.isFavorite
            existing.tags = resolvedTags
            existing.updatedAt = Date()
            
        } else {
            
            let entity = NoteEntity(
                id: note.id,
                title: note.title,
                content: note.content,
                isFavorite: note.isFavorite,
                tags: resolvedTags,
                createdAt: note.createdAt,
                updatedAt: note.updatedAt
            )
            
            context.insert(entity)
        }
        
        try context.save()
    }
    
    
    func delete(_ note: Note) throws {
        let entities = try context.fetch(FetchDescriptor<NoteEntity>())
        
        if let entity = entities.first(where: { $0.id == note.id }) {
            context.delete(entity)
            try context.save()
        }
    }
}
