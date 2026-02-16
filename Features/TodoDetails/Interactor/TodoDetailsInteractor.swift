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
        Task { [weak self] in
            guard let self else { return }
            
            do {
                if try await repository.exists(todoID: todo.id) {
                    try await repository.update(todo: todo)
                } else {
                    try await repository.add(todo: todo)
                }
                self.output?.didSaveTodo()
            } catch {
                self.output?.didFailSaving(error: error)
            }
        }
    }
}
