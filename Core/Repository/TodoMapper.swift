//
//  TodoMapper.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation
import CoreData

enum TodoMapper {
    
    // MARK: - DTO → Domain
    
    static func map(dto: TodoDTO) -> Todo {
        return Todo(
            id: UUID(),
            title: dto.todo,
            details: nil,
            createdAt: Date(),
            isCompleted: dto.completed
        )
    }
    
    // MARK: - Domain → CoreData
    
    static func map(domain: Todo, context: NSManagedObjectContext) -> TodoEntity {
        let entity = TodoEntity(context: context)
        entity.id = domain.id
        entity.title = domain.title
        entity.details = domain.details
        entity.createdAt = domain.createdAt
        entity.isCompleted = domain.isCompleted
        return entity
    }
    
    // MARK: - CoreData → Domain
    
    static func map(entity: TodoEntity) -> Todo {
        return Todo(
            id: entity.id ?? UUID(),
            title: entity.title ?? "",
            details: entity.details,
            createdAt: entity.createdAt ?? Date(),
            isCompleted: entity.isCompleted
        )
    }
}
