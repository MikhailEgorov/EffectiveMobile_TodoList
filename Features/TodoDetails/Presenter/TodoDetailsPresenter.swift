//
//  TodoDetailsPresenter.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation

final class TodoDetailsPresenter: TodoDetailsViewOutput {
    
    weak var view: TodoDetailsViewInput?
    var interactor: TodoDetailsInteractorInput
    var router: TodoDetailsRouterInput
    
    weak var moduleOutput: TodoDetailsModuleOutput?
    
    private var todo: Todo?
    private var savedTodo: Todo?
    
    init(view: TodoDetailsViewInput,
         interactor: TodoDetailsInteractorInput,
         router: TodoDetailsRouterInput,
         todo: Todo?) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        self.todo = todo
    }
    
    func viewDidLoad() {
        view?.configure(with: todo)
    }
    
    func didTapSave(title: String, description: String?) {
        let updatedTodo = Todo(
            id: todo?.id ?? UUID(),
            title: title,
            details: description,
            createdAt: todo?.createdAt ?? Date(),
            isCompleted: todo?.isCompleted ?? false
        )
        savedTodo = updatedTodo
        interactor.save(todo: updatedTodo)
    }
}

// MARK: - Interactor Output
extension TodoDetailsPresenter: TodoDetailsInteractorOutput {
    
    func didSaveTodo() {
        moduleOutput?.didFinishEditing()
        router.close()
    }
    
    func didFailSaving(error: Error) {
        print(error)
    }
}
