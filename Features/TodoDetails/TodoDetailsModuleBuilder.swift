//
//  TodoDetailsModuleBuilder.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoDetailsModuleBuilder {
    static func build(
        todo: Todo?,
        moduleOutput: TodoDetailsModuleOutput,
        repository: TodoRepositoryProtocol
    ) -> UIViewController {
        
        let view = TodoDetailsViewController()
        let interactor = TodoDetailsInteractor(repository: repository)
        let router = TodoDetailsRouter()
        router.viewController = view
        
        let presenter = TodoDetailsPresenter(
            view: view,
            interactor: interactor,
            router: router,
            todo: todo
        )
        
        view.output = presenter
        interactor.output = presenter
        presenter.moduleOutput = moduleOutput
        
        return view
    }
}
