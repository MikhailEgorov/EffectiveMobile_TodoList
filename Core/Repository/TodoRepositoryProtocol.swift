//
//  TodoRepositoryProtocol.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation

protocol TodoRepositoryProtocol {
    func fetchLocalTodos() async throws -> [Todo]
    func fetchRemoteTodos() async throws -> [Todo]
    func saveTodos(_ todos: [Todo]) async throws
    func add(todo: Todo) async throws
    func update(todo: Todo) async throws
    func delete(todoID: UUID) async throws
    func search(query: String) async throws -> [Todo]
    func exists(todoID: UUID) async throws -> Bool
}
