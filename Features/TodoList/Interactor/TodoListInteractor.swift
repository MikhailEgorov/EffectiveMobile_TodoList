//
//  TodoListInteractor.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation

final class TodoListInteractor: TodoListInteractorInput {
    
    weak var output: TodoListInteractorOutput?
    
    func fetchTodos() {}
    func addTodo(_ todo: Todo) {}
    func updateTodo(_ todo: Todo) {}
    func deleteTodo(_ todo: Todo) {}
    func searchTodos(query: String) {}
}
