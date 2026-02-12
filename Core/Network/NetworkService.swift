//
//  NetworkService.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 12.02.2026.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    private let baseURL = "https://dummyjson.com/todos"
    
    func fetchTodos() async throws -> [TodoDTO] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = try decoder.decode(TodoResponse.self, from: data)
        return result.todos
    }
}

// MARK: - Response Wrapper

struct TodoResponse: Decodable {
    let todos: [TodoDTO]
}
