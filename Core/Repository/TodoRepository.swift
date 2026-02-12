//
//  TodoRepository.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation
import CoreData

final class TodoRepository: TodoRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let coreDataStack: CoreDataStack
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         coreDataStack: CoreDataStack = .shared) {
        self.networkService = networkService
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Fetch Local
    
    func fetchLocalTodos() async throws -> [Todo] {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                
                do {
                    let entities = try context.fetch(request)
                    let todos = entities.map { TodoMapper.map(entity: $0) }
                    continuation.resume(returning: todos)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Fetch Remote
    
    func fetchRemoteTodos() async throws -> [Todo] {
        let dtos = try await networkService.fetchTodos()
        let todos = dtos.map { TodoMapper.map(dto: $0) }
        try await saveTodos(todos)
        return todos
    }
    
    // MARK: - Save
    
    func saveTodos(_ todos: [Todo]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    for todo in todos {
                        _ = TodoMapper.map(domain: todo, context: context)
                    }
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Add
    
    func add(todo: Todo) async throws {
        try await saveTodos([todo])
    }
    
    // MARK: - Update
    
    func update(todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
                
                do {
                    if let entity = try context.fetch(request).first {
                        entity.title = todo.title
                        entity.details = todo.details
                        entity.isCompleted = todo.isCompleted
                        entity.createdAt = todo.createdAt
                        try context.save()
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: NSError(domain: "TodoRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"]))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Delete
    
    func delete(todoID: UUID) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", todoID as CVarArg)
                
                do {
                    if let entity = try context.fetch(request).first {
                        context.delete(entity)
                        try context.save()
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: NSError(domain: "TodoRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"]))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Search
    
    func search(query: String) async throws -> [Todo] {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
                
                do {
                    let entities = try context.fetch(request)
                    let todos = entities.map { TodoMapper.map(entity: $0) }
                    continuation.resume(returning: todos)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
