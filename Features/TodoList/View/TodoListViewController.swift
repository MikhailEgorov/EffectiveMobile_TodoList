//
//  TodoListViewController.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoListViewController: UIViewController, TodoListViewInput {
    
    var output: TodoListViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        output.viewDidLoad()
    }
    
    func showTodos(_ todos: [Todo]) {
        // Пока пусто
    }
    
    func showError(_ error: Error) {
        // Пока пусто
    }
}
