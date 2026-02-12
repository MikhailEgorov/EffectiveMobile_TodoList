//
//  Todo.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation

struct Todo: Identifiable {
    let id: UUID
    var title: String
    var details: String?
    let createdAt: Date
    var isCompleted: Bool
}
