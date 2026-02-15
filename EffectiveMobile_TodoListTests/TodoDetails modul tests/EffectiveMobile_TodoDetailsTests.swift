//
//  EffectiveMobile_TodoDetailsTests.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 15.02.2026.
//

import XCTest
@testable import EffectiveMobile_TodoList

@MainActor
final class TodoDetailsPresenterTests: XCTestCase {
    
    func test_viewDidLoad_whenTodoExists_callsConfigureWithTodo() {
        // Arrange
        let viewSpy = TodoDetailsViewMock()
        let interactor = TodoDetailsInteractorMock()
        let router = TodoDetailsRouterMock()
        
        let todo = Todo(
            id: UUID(),
            title: "Test",
            details: "Details",
            createdAt: Date(),
            isCompleted: false
        )
        
        let presenter = TodoDetailsPresenter(
            view: viewSpy,
            interactor: interactor,
            router: router,
            todo: todo
        )
        
        // Act
        presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(viewSpy.configureCalled)
        XCTAssertEqual(viewSpy.receivedTodo?.id, todo.id)
    }
    
    func test_viewDidLoad_whenTodoIsNil_callsConfigureWithNil() {
        // Arrange
        let viewSpy = TodoDetailsViewMock()
        let interactor = TodoDetailsInteractorMock()
        let router = TodoDetailsRouterMock()
        
        let presenter = TodoDetailsPresenter(
            view: viewSpy,
            interactor: interactor,
            router: router,
            todo: nil
        )
        
        // Act
        presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(viewSpy.configureCalled)
        XCTAssertNil(viewSpy.receivedTodo)
    }
    
    func test_didTapSave_whenEditingExistingTodo_callsInteractorWithUpdatedTodo() {
        // Arrange
        let viewSpy = TodoDetailsViewMock()
        let interactorMock = TodoDetailsInteractorMock()
        let routerMock = TodoDetailsRouterMock()
        
        let existingDate = Date(timeIntervalSince1970: 1000)
        let existingId = UUID()
        
        let existingTodo = Todo(
            id: existingId,
            title: "Old title",
            details: "Old details",
            createdAt: existingDate,
            isCompleted: true
        )
        
        let presenter = TodoDetailsPresenter(
            view: viewSpy,
            interactor: interactorMock,
            router: routerMock,
            todo: existingTodo
        )
        
        // Act
        presenter.didTapSave(title: "New title", description: "New details")
        
        // Assert
        XCTAssertTrue(interactorMock.saveCalled)
        
        let savedTodo = interactorMock.receivedTodo
        XCTAssertEqual(savedTodo?.id, existingId)
        XCTAssertEqual(savedTodo?.title, "New title")
        XCTAssertEqual(savedTodo?.details, "New details")
        XCTAssertEqual(savedTodo?.createdAt, existingDate)
        XCTAssertEqual(savedTodo?.isCompleted, true)
    }
    
    func test_didTapSave_whenCreatingNewTodo_callsInteractorWithNewTodo() {
        // Arrange
        let viewSpy = TodoDetailsViewMock()
        let interactorMock = TodoDetailsInteractorMock()
        let routerMock = TodoDetailsRouterMock()
        
        let presenter = TodoDetailsPresenter(
            view: viewSpy,
            interactor: interactorMock,
            router: routerMock,
            todo: nil
        )
        
        // Act
        presenter.didTapSave(title: "New title", description: "Details")
        
        // Assert
        XCTAssertTrue(interactorMock.saveCalled)
        
        let savedTodo = interactorMock.receivedTodo
        XCTAssertEqual(savedTodo?.title, "New title")
        XCTAssertEqual(savedTodo?.details, "Details")
        XCTAssertEqual(savedTodo?.isCompleted, false)
        XCTAssertNotNil(savedTodo?.id)
        XCTAssertNotNil(savedTodo?.createdAt)
    }
    
    func test_didSaveTodo_callsModuleOutputAndClosesRouter() {
        // Arrange
        let viewMock = TodoDetailsViewMock()
        let interactorMock = TodoDetailsInteractorMock()
        let routerMock = TodoDetailsRouterMock()
        let moduleOutputMock = TodoDetailsOutputMock()
        
        let presenter = TodoDetailsPresenter(
            view: viewMock,
            interactor: interactorMock,
            router: routerMock,
            todo: nil
        )
        
        presenter.moduleOutput = moduleOutputMock
        
        // Act
        presenter.didSaveTodo()
        
        // Assert
        XCTAssertTrue(moduleOutputMock.didFinishEditingCalled)
        XCTAssertTrue(routerMock.closeCalled)
    }
    
}

@MainActor
final class TodoDetailsInteractorTests: XCTestCase {
    
    func test_save_whenTodoExists_callsUpdateAndDidSave() {
        // Arrange
        let repositoryMock = TodoDetailsRepositoryMock()
        let outputMock = TodoDetailsInteractorOutputMock()
        
        let existingId = UUID()
        
        repositoryMock.todos = [
            Todo(id: existingId,
                 title: "Old",
                 details: nil,
                 createdAt: Date(),
                 isCompleted: false)
        ]
        
        let interactor = TodoDetailsInteractor(repository: repositoryMock)
        interactor.output = outputMock
        
        let expectation = expectation(description: "Async save")
        
        // Act
        interactor.save(todo: repositoryMock.todos[0])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        // Assert
        XCTAssertTrue(repositoryMock.fetchLocalTodosCalled)
        XCTAssertTrue(repositoryMock.updateCalled)
        XCTAssertFalse(repositoryMock.addCalled)
        XCTAssertTrue(outputMock.didSaveCalled)
        XCTAssertFalse(outputMock.didFailCalled)
    }
    
    func test_save_whenTodoDoesNotExist_callsAddAndDidSave() {
        // Arrange
        let repositoryMock = TodoDetailsRepositoryMock()
        let outputMock = TodoDetailsInteractorOutputMock()
        
        repositoryMock.todos = [] // empty array
        
        let interactor = TodoDetailsInteractor(repository: repositoryMock)
        interactor.output = outputMock
        
        let newTodo = Todo(
            id: UUID(),
            title: "New",
            details: nil,
            createdAt: Date(),
            isCompleted: false
        )
        
        let expectation = expectation(description: "Async save")
        
        // Act
        interactor.save(todo: newTodo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        // Assert
        XCTAssertTrue(repositoryMock.fetchLocalTodosCalled)
        XCTAssertFalse(repositoryMock.updateCalled)
        XCTAssertTrue(repositoryMock.addCalled)
        XCTAssertTrue(outputMock.didSaveCalled)
        XCTAssertFalse(outputMock.didFailCalled)
    }
}

@MainActor
final class TodoDetailsRepositoryTests: XCTestCase {
    func test_addTodo_thenFetchLocal_returnsAddedTodo() async throws {
        // Arrange
        let coreDataStack: CoreDataStackProtocol = TodoInMemoryCoreDataStack()
        let repository = TodoRepository(networkService: NetworkServiceMock(),
                                        coreDataStack: coreDataStack)
        
        let todo = Todo(id: UUID(),
                        title: "Test",
                        details: "Desc",
                        createdAt: Date(),
                        isCompleted: false)
        
        // Act
        try await repository.add(todo: todo)
        let todos = try await repository.fetchLocalTodos()
        
        // Assert
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.id, todo.id)
    }
    
    func test_updateExistingTodo_updatesCorrectly() async throws {
        // Arrange
        let coreDataStack: CoreDataStackProtocol = TodoInMemoryCoreDataStack()
        let repository = TodoRepository(networkService: NetworkServiceMock(),
                                        coreDataStack: coreDataStack)
        
        var todo = Todo(id: UUID(),
                        title: "Old",
                        details: "Old",
                        createdAt: Date(),
                        isCompleted: false)
        
        try await repository.add(todo: todo)
        
        // Act
        todo.title = "New"
        todo.details = "New"
        try await repository.update(todo: todo)
        
        let todos = try await repository.fetchLocalTodos()
        
        // Assert
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, "New")
        XCTAssertEqual(todos.first?.details, "New")
    }
    
    func test_updateNonExistingTodo_throwsError() async {
        // Arrange
        let coreDataStack: CoreDataStackProtocol = TodoInMemoryCoreDataStack()
        let repository = TodoRepository(networkService: NetworkServiceMock(),
                                        coreDataStack: coreDataStack)
        
        let todo = Todo(id: UUID(),
                        title: "Test",
                        details: nil,
                        createdAt: Date(),
                        isCompleted: false)
        
        // Act & Assert
        do {
            try await repository.update(todo: todo)
            XCTFail("Expected update to throw an error, but it succeeded")
        } catch {
            // Error was bring - test complete
        }
    }
}
