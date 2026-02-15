//
//  TodoListPresenter.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation
import UIKit

final class TodoListPresenter: TodoListViewOutput {
    
    
    weak var view: TodoListViewInput?
    var interactor: TodoListInteractorInput
    var router: TodoListRouting
    
    private let repository: TodoRepositoryProtocol
    private var searchTask: Task<Void, Never>?
    
    init(view: TodoListViewInput,
         interactor: TodoListInteractorInput,
         router: TodoListRouting,
         repository: TodoRepositoryProtocol) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        self.repository = repository
    }
    
    deinit {
        searchTask?.cancel()
    }
    
    // MARK: - TodoListViewOutput methods
    
    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func didTapAddTodo() {
        guard let view = view as? UIViewController else { return }
        router.openTodoDetailsForAdd(from: view, repository: repository, moduleOutput: self)
    }

    func didSelectTodo(_ todo: Todo) {
        guard let view = view as? UIViewController else { return }
        router.openTodoDetailsForEdit(todo, from: view, repository: repository, moduleOutput: self)
    }

    func didToggleComplete(_ todo: Todo) {
        var updated = todo
        updated.isCompleted.toggle()
        interactor.updateTodo(updated)
    }

    func didDeleteTodo(_ todo: Todo) {
        interactor.deleteTodo(todo)
    }

    func didSearch(query: String) {
        searchTask?.cancel()
        
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                if query.isEmpty {
                    self?.interactor.fetchTodos()
                } else {
                    self?.interactor.searchTodos(query: query)
                }
            }
        }
    }
    
    func didCancelSearch() {
        interactor.fetchTodos()
    }
}

extension TodoListPresenter: TodoListInteractorOutput {
    func todosFetched(_ todos: [Todo]) {
        DispatchQueue.main.async {
            self.view?.showTodos(todos)
        }
    }

    func todosFetchFailed(_ error: Error) {
        DispatchQueue.main.async {
            self.view?.showError(error)
        }
    }
}

extension TodoListPresenter: TodoDetailsModuleOutput {

    func didFinishEditing() {
        interactor.fetchTodos()
    }
}
