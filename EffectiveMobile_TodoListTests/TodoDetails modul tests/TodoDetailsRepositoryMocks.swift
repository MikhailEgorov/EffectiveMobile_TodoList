//
//  TodoDetailsRepositoryMocks.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 15.02.2026.
//

@testable import EffectiveMobile_TodoList
import UIKit
import CoreData

final class NetworkServiceMock: NetworkServiceProtocol {
    var todosToReturn: [TodoDTO] = []
    
    func fetchTodos() async throws -> [TodoDTO] {
        return todosToReturn
    }
}

final class DetailsInMemoryCoreDataStack: CoreDataStackProtocol {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory CoreData: \(error)")
            }
        }

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
        }
    }
}
