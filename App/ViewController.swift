//
//  ViewController.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        
        // Network ping test
        Task {
            do {
                let todos = try await NetworkService().fetchTodos()
                print(todos)
            } catch {
                print(error)
            }
        }

    }
}
