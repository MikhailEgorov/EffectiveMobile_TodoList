//
//  TodoListModuleBuilder.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoListModuleBuilder {
    
    static func build() -> UIViewController {
        let view = TodoListViewController()
        
        let repository = TodoRepository()
        let interactor = TodoListInteractor(repository: repository)
        let router = TodoListRouter()
        let presenter = TodoListPresenter(view: view,
                                          interactor: interactor,
                                          router: router,
                                          repository: repository)
        
        view.output = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}
