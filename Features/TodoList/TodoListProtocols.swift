//
//  TodoListProtocols.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation
import UIKit

// MARK: - View → Presenter
protocol TodoListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapAddTodo()
    func didSelectTodo(_ todo: Todo)
    func didToggleComplete(_ todo: Todo)
    func didDeleteTodo(_ todo: Todo)
    func didSearch(query: String)
    func didCancelSearch()
}

// MARK: - Presenter → View
protocol TodoListViewInput: AnyObject {
    func showTodos(_ todos: [Todo])
    func showError(_ error: Error)
}

// MARK: - Presenter → Interactor
protocol TodoListInteractorInput: AnyObject {
    func fetchTodos()
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
    func searchTodos(query: String)
}

// MARK: - Interactor → Presenter
protocol TodoListInteractorOutput: AnyObject {
    func todosFetched(_ todos: [Todo])
    func todosFetchFailed(_ error: Error)
}

// MARK: - Router
protocol TodoListRouting {
    func openTodoDetailsForAdd(from viewController: UIViewController, repository: TodoRepositoryProtocol, moduleOutput: TodoDetailsModuleOutput)
    func openTodoDetailsForEdit(_ todo: Todo, from viewController: UIViewController, repository: TodoRepositoryProtocol, moduleOutput: TodoDetailsModuleOutput)
}
