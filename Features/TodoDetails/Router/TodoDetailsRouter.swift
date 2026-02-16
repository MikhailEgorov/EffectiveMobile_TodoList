//
//  TodoDetailsRouter.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoDetailsRouter: TodoDetailsRouterInput {

    // MARK: - Navigation
    weak var viewController: UIViewController?

    // MARK: - Inside modul navigation methods
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
