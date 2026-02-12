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
            let repo = TodoRepository()
            do {
                let local = try await repo.fetchLocalTodos()
                print("Local:", local)
                
                let remote = try await repo.fetchRemoteTodos()
                print("Remote:", remote)
                
            } catch {
                print(error)
            }
        }


    }
}
