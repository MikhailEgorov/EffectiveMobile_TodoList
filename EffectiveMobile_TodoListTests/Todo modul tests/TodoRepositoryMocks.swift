//
//  RepositoryMocks.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 15.02.2026.
//

@testable import EffectiveMobile_TodoList
import UIKit
import CoreData

final class TodoNetworkServiceMock: NetworkServiceProtocol {
    var todosToReturn: [TodoDTO] = []
    var errorToThrow: Error?

    func fetchTodos() async throws -> [TodoDTO] {
        if let error = errorToThrow { throw error }
        return todosToReturn
    }
}

final class TodoInMemoryCoreDataStack: CoreDataStackProtocol {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            if let error = error { fatalError(error.localizedDescription) }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
