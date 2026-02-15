//
//  EffectiveMobile_TodoListTests.swift
//  EffectiveMobile_TodoListTests
//
//  Created by Mikhail Egorov on 14.02.2026.
//
import XCTest
@testable import EffectiveMobile_TodoList
import CoreData

@MainActor
final class TodoListPresenterTests: XCTestCase {
    
    func test_viewDidLoad_callsInteractorFetchTodos() {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        // Act
        presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
        
    }
    
    func test_didTapAddTodo_callsRouterOpenAdd() {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        // Act
        presenter.didTapAddTodo()
        
        // Assert
        XCTAssertTrue(mockRouter.didCallAdd)
    }
    
    func test_didSelectTodo_callsRouterOpenEdit_withCorrectTodo() {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        let todo = Todo(id: UUID(), title: "Test", details: nil, createdAt: Date(), isCompleted: false)
        
        // Act
        presenter.didSelectTodo(todo)
        
        // Assert
        XCTAssertTrue(mockRouter.didCallEdit)
        XCTAssertEqual(mockRouter.lastTodo?.id, todo.id)
    }
    
    func test_didToggleComplete_callsInteractorUpdate_withToggledTodo() {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        let todo = Todo(id: UUID(), title: "Test", details: nil, createdAt: Date(), isCompleted: false)
        
        // Act
        presenter.didToggleComplete(todo)
        
        // Assert
        XCTAssertNotNil(mockInteractor.updateTodoCalledWith)
        XCTAssertEqual(mockInteractor.updateTodoCalledWith?.id, todo.id)
        XCTAssertEqual(mockInteractor.updateTodoCalledWith?.isCompleted, !todo.isCompleted)
    }
    
    func test_didDeleteTodo_callsInteractorDelete() {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        let todo = Todo(id: UUID(), title: "Test", details: nil, createdAt: Date(), isCompleted: false)
        
        // Act
        presenter.didDeleteTodo(todo)
        
        // Assert
        XCTAssertNotNil(mockInteractor.deleteTodoCalledWith)
        XCTAssertEqual(mockInteractor.deleteTodoCalledWith?.id, todo.id)
    }
    
    func test_didSearch_callsInteractorSearch_forNonEmptyQuery() async {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        // Act
        presenter.didSearch(query: "hello")
        
        // Wait debounce
        try? await Task.sleep(nanoseconds: 350_000_000)
        
        // Assert
        XCTAssertEqual(mockInteractor.searchTodosCalledWith, "hello")
    }
    
    func test_didSearch_callsInteractorFetch_forEmptyQuery() async {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        // Act
        presenter.didSearch(query: "")
        
        try? await Task.sleep(nanoseconds: 350_000_000)
        
        // Assert
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }
    
    func test_didCancelSearch_callsInteractorFetchTodos() {
        // Arrange
        let mockView = TodoViewMock()
        let mockInteractor = TodoInteractorMock()
        let mockRouter = TodoRouterMock()
        let mockRepository = TodoRepositoryMock()
        
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            repository: mockRepository
        )
        
        // Act
        presenter.didCancelSearch()
        
        // Assert
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }
    
    func test_todosFetched_callsViewShowTodos() {
        let mockView = TodoViewMock()
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: TodoInteractorMock(),
            router: TodoRouterMock(),
            repository: TodoRepositoryMock()
        )
        
        let todos = [Todo(id: UUID(), title: "A", details: nil, createdAt: Date(), isCompleted: false)]
        let expectation = expectation(description: "View receives todos")
        
        // Act - callback call
        presenter.todosFetched(todos)
        
        // let the main queue handle DispatchQueue.main.async inside the presenter
        DispatchQueue.main.async {
            XCTAssertEqual(mockView.todosShown?.count, todos.count)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    func test_todosFetchFailed_callsViewShowError() {
        let mockView = TodoViewMock()
        let presenter = TodoListPresenter(
            view: mockView,
            interactor: TodoInteractorMock(),
            router: TodoRouterMock(),
            repository: TodoRepositoryMock()
        )
        
        let error = NSError(domain: "test", code: 1)
        let expectation = expectation(description: "View receives error")
        
        // Act - callback call
        presenter.todosFetchFailed(error)
        
        // let the main queue handle DispatchQueue.main.async inside the presenter
        DispatchQueue.main.async {
            XCTAssertNotNil(mockView.errorShown)
            XCTAssertEqual((mockView.errorShown as NSError?)?.code, error.code)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

@MainActor
final class TodoListInteractorTests: XCTestCase {
    
    func test_fetchTodos_whenLocalExists_returnsLocal() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        let todo = Todo(
            id: UUID(),
            title: "Local",
            details: nil,
            createdAt: Date(),
            isCompleted: false
        )
        
        repository.localTodos = [todo]
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.fetchTodos()
        
        // Let's run the Task inside the interactor
        await Task.yield()
        
        XCTAssertEqual(output.fetchedTodos?.count, 1)
        XCTAssertFalse(repository.fetchRemoteCalled)
    }
    
    
    func test_fetchTodos_whenLocalEmpty_fetchesRemote() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        repository.localTodos = []
        repository.remoteTodos = [
            Todo(
                id: UUID(),
                title: "Remote",
                details: nil,
                createdAt: Date(),
                isCompleted: false
            )
        ]
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.fetchTodos()
        
        await Task.yield()
        
        XCTAssertTrue(repository.fetchRemoteCalled)
        XCTAssertEqual(output.fetchedTodos?.count, 1)
    }
    
    
    func test_fetchTodos_whenError_callsFetchFailed() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        repository.errorToThrow = NSError(domain: "test", code: 1)
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.fetchTodos()
        
        await Task.yield()
        
        XCTAssertNotNil(output.fetchError)
    }
    
    func test_updateTodo_callsRepositoryUpdate_andReturnsTodos() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        let todo = Todo(id: UUID(), title: "Update", details: nil, createdAt: Date(), isCompleted: false)
        repository.localTodos = [todo]
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.updateTodo(todo)
        
        await Task.yield()
        
        XCTAssertEqual(repository.updateCalledWith?.id, todo.id)
        XCTAssertEqual(output.fetchedTodos?.count, 1)
    }
    
    func test_deleteTodo_callsRepositoryDelete_andReturnsTodos() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        let todo = Todo(id: UUID(), title: "Delete", details: nil, createdAt: Date(), isCompleted: false)
        repository.localTodos = [todo]
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.deleteTodo(todo)
        
        await Task.yield()
        
        XCTAssertEqual(repository.deleteCalledWith, todo.id)
        XCTAssertEqual(output.fetchedTodos?.count, 1)
    }
    
    func test_searchTodos_withQuery_callsRepositorySearch() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        let todo = Todo(id: UUID(), title: "Search", details: nil, createdAt: Date(), isCompleted: false)
        repository.searchResults = [todo]
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.searchTodos(query: "Search")
        
        await Task.yield()
        
        XCTAssertEqual(repository.searchCalledWith, "Search")
        XCTAssertEqual(output.fetchedTodos?.count, 1)
    }
    
    func test_searchTodos_withEmptyQuery_fetchesLocalTodos() async {
        let repository = TodoRepositoryForInteractorMock()
        let output = TodoInteractorOutputMock()
        
        let todo = Todo(id: UUID(), title: "LocalSearch", details: nil, createdAt: Date(), isCompleted: false)
        repository.localTodos = [todo]
        
        let interactor = TodoListInteractor(repository: repository)
        interactor.output = output
        
        interactor.searchTodos(query: "  ") // empty row after trim
        
        await Task.yield()
        
        XCTAssertTrue(repository.fetchLocalCalled)
        XCTAssertEqual(output.fetchedTodos?.count, 1)
    }
    
}

@MainActor
final class TodoRepositoryTests: XCTestCase {
    
    var coreDataStack: CoreDataStackProtocol!
    var repository: TodoRepository!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TodoInMemoryCoreDataStack()
        repository = TodoRepository(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        repository = nil
        coreDataStack = nil
        super.tearDown()
    }
    
    func test_fetchLocalTodos_returnsSavedTodos() async throws {
        // Arrange - Create and save a Todo in in-memory CoreData
        let context = coreDataStack.viewContext
        let todo = Todo(id: UUID(), title: "Test Local", details: "Details", createdAt: Date(), isCompleted: false)
        _ = TodoMapper.map(domain: todo, context: context)
        try context.save()
        
        // Act
        let fetchedTodos = try await repository.fetchLocalTodos()
        
        // Assert
        XCTAssertEqual(fetchedTodos.count, 1)
        XCTAssertEqual(fetchedTodos.first?.title, "Test Local")
        XCTAssertEqual(fetchedTodos.first?.details, "Details")
    }
    
    func test_fetchRemoteTodos_returnsMappedAndSavedTodos() async throws {
        // Arrange
        let networkService = TodoNetworkServiceMock()
        let coreDataStack = TodoInMemoryCoreDataStack()
        let repository = TodoRepository(networkService: networkService, coreDataStack: coreDataStack)
        
        let dto = TodoDTO(id: 1, todo: "Remote Task", completed: false)
        networkService.todosToReturn = [dto]
        
        // Act
        let todos = try await repository.fetchRemoteTodos()
        
        // Assert
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, dto.todo)
        
        // We check that they are actually saved in Core Data
        let savedTodos = try await repository.fetchLocalTodos()
        XCTAssertEqual(savedTodos.count, 1)
        XCTAssertEqual(savedTodos.first?.title, dto.todo)
    }
    
    func test_saveTodos_savesTodosToCoreData() async throws {
        // Arrange
        let todo1 = Todo(id: UUID(), title: "Task 1", details: nil, createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Task 2", details: "Details", createdAt: Date(), isCompleted: true)
        
        // Act
        try await repository.saveTodos([todo1, todo2])
        
        // Assert
        let savedTodos = try await repository.fetchLocalTodos()
        XCTAssertEqual(savedTodos.count, 2)
        XCTAssertTrue(savedTodos.contains { $0.title == "Task 1" && !$0.isCompleted })
        XCTAssertTrue(savedTodos.contains { $0.title == "Task 2" && $0.isCompleted })
    }
    
    func test_addTodo_savesTodoToCoreData() async throws {
        // Arrange
        let todo = Todo(
            id: UUID(),
            title: "New Task",
            details: "Some details",
            createdAt: Date(),
            isCompleted: false
        )
        
        // Act
        try await repository.add(todo: todo)
        
        // Assert
        let savedTodos = try await repository.fetchLocalTodos()
        XCTAssertEqual(savedTodos.count, 1)
        XCTAssertEqual(savedTodos.first?.title, "New Task")
        XCTAssertEqual(savedTodos.first?.details, "Some details")
        XCTAssertFalse(savedTodos.first!.isCompleted)
    }
    
    func test_updateTodo_updatesExistingTodoInCoreData() async throws {
        // Arrange - Save the original todo
        let todo = Todo(
            id: UUID(),
            title: "Original Task",
            details: "Original details",
            createdAt: Date(),
            isCompleted: false
        )
        _ = TodoMapper.map(domain: todo, context: coreDataStack.viewContext)
        try coreDataStack.viewContext.save()
        
        // Создаем обновленный todo с тем же id
        var updatedTodo = todo
        updatedTodo.title = "Updated Task"
        updatedTodo.details = "Updated details"
        updatedTodo.isCompleted = true
        
        // Act
        try await repository.update(todo: updatedTodo)
        
        // Assert
        let savedTodos = try await repository.fetchLocalTodos()
        XCTAssertEqual(savedTodos.count, 1)
        let fetched = savedTodos.first!
        XCTAssertEqual(fetched.id, todo.id)
        XCTAssertEqual(fetched.title, "Updated Task")
        XCTAssertEqual(fetched.details, "Updated details")
        XCTAssertTrue(fetched.isCompleted)
    }
    
    func test_updateTodo_throwsErrorWhenTodoNotFound() async throws {
        // Arrange - создаем todo с id, которого нет в Core Data
        let todo = Todo(
            id: UUID(),
            title: "Nonexistent",
            details: nil,
            createdAt: Date(),
            isCompleted: false
        )
        
        // Act & Assert
        do {
            try await repository.update(todo: todo)
            XCTFail("Expected update to throw an error for non-existent Todo")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TodoRepository")
            XCTAssertEqual(nsError.code, 404)
        }
    }
    
    func test_deleteTodo_removesExistingTodoFromCoreData() async throws {
        // Arrange - сохраняем Todo в Core Data
        let todo = Todo(
            id: UUID(),
            title: "Task to delete",
            details: "Some details",
            createdAt: Date(),
            isCompleted: false
        )
        _ = TodoMapper.map(domain: todo, context: coreDataStack.viewContext)
        try coreDataStack.viewContext.save()
        
        // Act
        try await repository.delete(todoID: todo.id)
        
        // Assert
        let todosAfterDelete = try await repository.fetchLocalTodos()
        XCTAssertTrue(todosAfterDelete.isEmpty)
    }
    
    func test_deleteTodo_throwsErrorWhenTodoNotFound() async throws {
        // Arrange - UUID, которого нет в Core Data
        let nonExistentID = UUID()
        
        // Act & Assert
        do {
            try await repository.delete(todoID: nonExistentID)
            XCTFail("Expected delete to throw an error for non-existent Todo")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TodoRepository")
            XCTAssertEqual(nsError.code, 404)
        }
    }
    
    func test_search_withEmptyQuery_returnsAllTodos() async throws {
        // Arrange
        let todo1 = Todo(id: UUID(), title: "Task 1", details: "Details 1", createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Task 2", details: "Details 2", createdAt: Date(), isCompleted: true)
        _ = TodoMapper.map(domain: todo1, context: coreDataStack.viewContext)
        _ = TodoMapper.map(domain: todo2, context: coreDataStack.viewContext)
        try coreDataStack.viewContext.save()
        
        // Act
        let results = try await repository.search(query: "")
        
        // Assert
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains(where: { $0.title == "Task 1" }))
        XCTAssertTrue(results.contains(where: { $0.title == "Task 2" }))
    }

    func test_search_withNonEmptyQuery_returnsFilteredTodos() async throws {
        // Arrange
        let todo1 = Todo(id: UUID(), title: "Buy milk", details: "2 liters", createdAt: Date(), isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Walk dog", details: "Evening walk", createdAt: Date(), isCompleted: false)
        _ = TodoMapper.map(domain: todo1, context: coreDataStack.viewContext)
        _ = TodoMapper.map(domain: todo2, context: coreDataStack.viewContext)
        try coreDataStack.viewContext.save()
        
        // Act
        let results = try await repository.search(query: "milk")
        
        // Assert
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Buy milk")
    }
}
