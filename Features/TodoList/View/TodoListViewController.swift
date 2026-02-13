//
//  TodoListViewController.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoListViewController: UIViewController, TodoListViewInput {
    
    var output: TodoListViewOutput!
    
    private var todos: [Todo] = []
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.viewDidLoad()
    }
    
    // MARK: - Public methods
    
    func showTodos(_ todos: [Todo]) {
        self.todos = todos
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        print("Ошибка:", error)
    }
}

// MARK: - SetupUI Methods

private extension TodoListViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        setupTableView()
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableView protocols

// UITableView DataSource
extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TodoCell",
            for: indexPath
        ) as? TodoCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.onToggle = { [weak self] in
            self?.output.didToggleComplete(todo)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let todo = todos[indexPath.row]
        output.didDeleteTodo(todo)
    }
}

// UITableView Delegate
extension TodoListViewController: UITableViewDelegate {
    
}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.didSearch(query: searchText)
    }
}
