//
//  PresenterMocks.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 14.02.2026.
//

@testable import EffectiveMobile_TodoList
import UIKit

final class TodoViewMock: UIViewController, TodoListViewInput {
    var todosShown: [Todo]?
    var errorShown: Error?
    
    var showTodosHandler: (([Todo]) -> Void)?
    var showErrorHandler: ((Error) -> Void)?
    
    func showTodos(_ todos: [Todo]) {
        todosShown = todos
    }
    
    func showError(_ error: Error) {
        errorShown = error
    }
}

final class TodoInteractorMock: TodoListInteractorInput {
    var fetchTodosCalled = false
    var updateTodoCalledWith: Todo?
    var deleteTodoCalledWith: Todo?
    var searchTodosCalledWith: String?
    
    func fetchTodos() {
        fetchTodosCalled = true
    }
    
    func updateTodo(_ todo: Todo) {
        updateTodoCalledWith = todo
    }
    
    func deleteTodo(_ todo: Todo) {
        deleteTodoCalledWith = todo
    }
    
    func searchTodos(query: String) {
        searchTodosCalledWith = query
    }
}

final class TodoRouterMock: TodoListRouting {
    var didCallAdd = false
    var didCallEdit = false
    var lastTodo: Todo?

    func openTodoDetailsForAdd(from viewController: UIViewController, repository: TodoRepositoryProtocol, moduleOutput: TodoDetailsModuleOutput) {
        didCallAdd = true
    }

    func openTodoDetailsForEdit(_ todo: Todo, from viewController: UIViewController, repository: TodoRepositoryProtocol, moduleOutput: TodoDetailsModuleOutput) {
        didCallEdit = true
        lastTodo = todo
    }
}

final class TodoRepositoryMock: TodoRepositoryProtocol {
    var fetchLocalTodosCalled = false
    var fetchRemoteTodosCalled = false
    
    func fetchLocalTodos() async throws -> [Todo] {
        fetchLocalTodosCalled = true
        return []
    }
    
    func fetchRemoteTodos() async throws -> [Todo] {
        fetchRemoteTodosCalled = true
        return []
    }
    
    func saveTodos(_ todos: [Todo]) async throws {}
    func add(todo: Todo) async throws {}
    func update(todo: Todo) async throws {}
    func delete(todoID: UUID) async throws {}
    func search(query: String) async throws -> [Todo] { return [] }
}
