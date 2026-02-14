//
//  TodoListRouter.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoListRouter {
    weak var viewController: UIViewController?
    
    func openTodoDetailsForAdd(from viewController: UIViewController, repository: TodoRepositoryProtocol, moduleOutput: TodoDetailsModuleOutput) {
        let detailsVC = TodoDetailsModuleBuilder.build(todo: nil, moduleOutput: moduleOutput, repository: repository)
        viewController.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func openTodoDetailsForEdit(_ todo: Todo, from viewController: UIViewController, repository: TodoRepositoryProtocol, moduleOutput: TodoDetailsModuleOutput) {
        let detailsVC = TodoDetailsModuleBuilder.build(todo: todo, moduleOutput: moduleOutput, repository: repository)
        viewController.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func navigateToAddTodo() {}
    func navigateToEditTodo(_ todo: Todo) {}
}
