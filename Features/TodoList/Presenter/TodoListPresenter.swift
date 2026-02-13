//
//  TodoListPresenter.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation

final class TodoListPresenter: TodoListViewOutput {
    
    weak var view: TodoListViewInput?
    var interactor: TodoListInteractorInput
    var router: TodoListRouter
    
    init(view: TodoListViewInput, interactor: TodoListInteractorInput, router: TodoListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func didTapAddTodo() {}
    func didSelectTodo(_ todo: Todo) {}
    func didToggleComplete(_ todo: Todo) {}
    func didDeleteTodo(_ todo: Todo) {}
    func didSearch(query: String) {}
}

extension TodoListPresenter: TodoListInteractorOutput {
    func todosFetched(_ todos: [Todo]) {}
    func todosFetchFailed(_ error: Error) {}
}
