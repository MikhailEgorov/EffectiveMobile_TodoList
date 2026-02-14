//
//  TodoDetailsInteractor.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

final class TodoDetailsInteractor: TodoDetailsInteractorInput {
    
    weak var output: TodoDetailsInteractorOutput?
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func save(todo: Todo) {
        Task {
            do {
                if try await repository.fetchLocalTodos().contains(where: { $0.id == todo.id }) {
                    try await repository.update(todo: todo)
                } else {
                    try await repository.add(todo: todo)
                }
                output?.didSaveTodo()
            } catch {
                output?.didFailSaving(error: error)
            }
        }
    }
}
