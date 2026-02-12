//
//  NetworkServiceProtocol.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos() async throws -> [TodoDTO]
}
