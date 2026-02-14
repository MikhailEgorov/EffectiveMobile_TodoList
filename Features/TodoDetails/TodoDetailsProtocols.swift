//
//  TodoDetailsProtocols.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import Foundation

protocol TodoDetailsViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String?)
}

protocol TodoDetailsViewInput: AnyObject {
    func configure(with todo: Todo?)
}

protocol TodoDetailsInteractorInput: AnyObject {
    func save(todo: Todo)
}

protocol TodoDetailsInteractorOutput: AnyObject {
    func didSaveTodo()
    func didFailSaving(error: Error)
}

protocol TodoDetailsModuleOutput: AnyObject {
    func didFinishEditing()
}
