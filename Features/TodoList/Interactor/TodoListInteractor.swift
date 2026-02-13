//
//  TodoListInteractor.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation

final class TodoListInteractor: TodoListInteractorInput {
    
    weak var output: TodoListInteractorOutput?
    
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchTodos() {
        Task {
            do {
                let localTodos = try await repository.fetchLocalTodos()
                
                if localTodos.isEmpty {
                    let remoteTodos = try await repository.fetchRemoteTodos()
                    output?.todosFetched(remoteTodos)
                } else {
                    output?.todosFetched(localTodos)
                }
            } catch {
                output?.todosFetchFailed(error)
            }
        }
    }
    
    func addTodo(_ todo: Todo) {}
    
    func updateTodo(_ todo: Todo) {
        Task {
            do {
                try await repository.update(todo: todo)
                let todos = try await repository.fetchLocalTodos()
                output?.todosFetched(todos)
            } catch {
                output?.todosFetchFailed(error)
            }
        }
    }

    func deleteTodo(_ todo: Todo) {
        Task {
            do {
                try await repository.delete(todoID: todo.id)
                let todos = try await repository.fetchLocalTodos()
                output?.todosFetched(todos)
            } catch {
                output?.todosFetchFailed(error)
            }
        }
    }

    func searchTodos(query: String) {
        Task {
            do {
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let todos = try await repository.fetchLocalTodos()
                    output?.todosFetched(todos)
                } else {
                    let results = try await repository.search(query: query)
                    output?.todosFetched(results)
                }
            } catch {
                output?.todosFetchFailed(error)
            }
        }
    }

}
