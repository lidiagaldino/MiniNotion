//
//  Note.swift
//  MiniNotion
//
//  Created by Lidia Galdino on 25/04/26.
//

import Foundation

struct Note: Identifiable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var tags: [Tag]
    var isFavorite: Bool
    let createdAt: Date
    var updatedAt: Date
}

