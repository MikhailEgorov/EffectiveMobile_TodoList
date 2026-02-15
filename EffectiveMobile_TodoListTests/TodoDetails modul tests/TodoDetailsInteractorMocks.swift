//
//  TodoDetailsInteractorMocks.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 15.02.2026.
//

import UIKit
@testable import EffectiveMobile_TodoList

final class TodoDetailsRepositoryMock: TodoRepositoryProtocol {

    var todos: [Todo] = []

    private(set) var fetchLocalTodosCalled = false
    private(set) var updateCalled = false
    private(set) var addCalled = false

    func fetchLocalTodos() async throws -> [Todo] {
        fetchLocalTodosCalled = true
        return todos
    }

    func update(todo: Todo) async throws {
        updateCalled = true
    }

    func add(todo: Todo) async throws {
        addCalled = true
    }

    // Остальные методы можно оставить fatalError
    func fetchRemoteTodos() async throws -> [Todo] { fatalError() }
    func saveTodos(_ todos: [Todo]) async throws { fatalError() }
    func delete(todoID: UUID) async throws { fatalError() }
    func search(query: String) async throws -> [Todo] { fatalError() }
}

final class TodoDetailsInteractorOutputMock: TodoDetailsInteractorOutput {

    private(set) var didSaveCalled = false
    private(set) var didFailCalled = false

    func didSaveTodo() {
        didSaveCalled = true
    }

    func didFailSaving(error: Error) {
        didFailCalled = true
    }
}

