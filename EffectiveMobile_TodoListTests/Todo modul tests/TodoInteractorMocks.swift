//
//  InteractorMocks.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 15.02.2026.
//

@testable import EffectiveMobile_TodoList
import UIKit

final class TodoInteractorOutputMock: TodoListInteractorOutput {
    var fetchedTodos: [Todo]?
    var fetchError: Error?
    
    func todosFetched(_ todos: [Todo]) {
        fetchedTodos = todos
    }
    
    func todosFetchFailed(_ error: Error) {
        fetchError = error
    }
}

final class TodoRepositoryForInteractorMock: TodoRepositoryProtocol {
    
    var localTodos: [Todo] = []
    var remoteTodos: [Todo] = []
    var searchResults: [Todo] = []
    
    var errorToThrow: Error?
    
    var fetchLocalCalled = false
    var fetchRemoteCalled = false
    var updateCalledWith: Todo?
    var deleteCalledWith: UUID?
    var searchCalledWith: String?
    
    func fetchLocalTodos() async throws -> [Todo] {
        fetchLocalCalled = true
        if let error = errorToThrow { throw error }
        return localTodos
    }
    
    func fetchRemoteTodos() async throws -> [Todo] {
        fetchRemoteCalled = true
        if let error = errorToThrow { throw error }
        return remoteTodos
    }
    
    func saveTodos(_ todos: [Todo]) async throws {}
    
    func add(todo: Todo) async throws {}
    
    func update(todo: Todo) async throws {
        updateCalledWith = todo
        if let error = errorToThrow { throw error }
    }
    
    func delete(todoID: UUID) async throws {
        deleteCalledWith = todoID
        if let error = errorToThrow { throw error }
    }
    
    func search(query: String) async throws -> [Todo] {
        searchCalledWith = query
        if let error = errorToThrow { throw error }
        return searchResults
    }
}
