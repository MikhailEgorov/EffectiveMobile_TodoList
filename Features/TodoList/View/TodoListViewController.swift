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
    
    private var countItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.viewDidLoad()
    }
    
    // MARK: - Public methods
    
    func showTodos(_ todos: [Todo]) {
        self.todos = todos
        tableView.reloadData()
        updateTaskCount()
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
        setupToolbar()
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupToolbar() {
        navigationController?.isToolbarHidden = false
        
        // Central text
        countItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        // Buttom "+"
        let addItem = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        let flexibleLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [
            flexibleLeft,
            countItem,
            flexibleRight,
            addItem
        ]
        
        updateTaskCount()
    }
    
    @objc private func addButtonTapped() {
        output.didTapAddTodo()
    }
    
    private func updateTaskCount() {
        countItem.title = "\(todos.count) Задач"
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

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    
    // Context menu when long press
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let todo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            // Edit
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.output.didSelectTodo(todo)
            }
            
            // Share
            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let activity = UIActivityViewController(activityItems: [todo.title], applicationActivities: nil)
                self.present(activity, animated: true)
            }
            
            // Delete
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.output.didDeleteTodo(todo)
            }
            
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
}


// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.didCancelSearch()
    }
}
