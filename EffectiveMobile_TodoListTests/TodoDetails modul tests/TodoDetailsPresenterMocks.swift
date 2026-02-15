//
//  PresenterMocks.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 15.02.2026.
//

import UIKit
@testable import EffectiveMobile_TodoList

final class TodoDetailsViewMock: TodoDetailsViewInput {

    private(set) var configureCalled = false
    private(set) var receivedTodo: Todo?

    func configure(with todo: Todo?) {
        configureCalled = true
        receivedTodo = todo
    }
}

final class TodoDetailsInteractorMock: TodoDetailsInteractorInput {

    private(set) var saveCalled = false
    private(set) var receivedTodo: Todo?

    func save(todo: Todo) {
        saveCalled = true
        receivedTodo = todo
    }
}


final class TodoDetailsRouterMock: TodoDetailsRouterInput {

    private(set) var closeCalled = false

    func close() {
        closeCalled = true
    }
}

final class TodoDetailsOutputMock: TodoDetailsModuleOutput {

    private(set) var didFinishEditingCalled = false

    func didFinishEditing() {
        didFinishEditingCalled = true
    }
}
