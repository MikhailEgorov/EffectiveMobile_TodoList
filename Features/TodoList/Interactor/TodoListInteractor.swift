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
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let localTodos = try await repository.fetchLocalTodos()
                
                if localTodos.isEmpty {
                    let remoteTodos = try await repository.fetchRemoteTodos()
                    self.output?.todosFetched(remoteTodos)
                } else {
                    self.output?.todosFetched(localTodos)
                }
            } catch {
                self.output?.todosFetchFailed(error)
            }
        }
    }
    
    func updateTodo(_ todo: Todo) {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await repository.update(todo: todo)
                let todos = try await repository.fetchLocalTodos()
                self.output?.todosFetched(todos)
            } catch {
                self.output?.todosFetchFailed(error)
            }
        }
    }

    func deleteTodo(_ todo: Todo) {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await repository.delete(todoID: todo.id)
                let todos = try await repository.fetchLocalTodos()
                self.output?.todosFetched(todos)
            } catch {
                self.output?.todosFetchFailed(error)
            }
        }
    }

    func searchTodos(query: String) {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let todos = try await repository.fetchLocalTodos()
                    self.output?.todosFetched(todos)
                } else {
                    let results = try await repository.search(query: query)
                    self.output?.todosFetched(results)
                }
            } catch {
                self.output?.todosFetchFailed(error)
            }
        }
    }

}
