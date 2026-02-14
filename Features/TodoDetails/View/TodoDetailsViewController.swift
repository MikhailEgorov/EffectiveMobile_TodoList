//
//  TodoDetailsViewController.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoDetailsViewController: UIViewController, TodoDetailsViewInput {

    // MARK: - VIPER
    var output: TodoDetailsViewOutput!

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Заголовок"
        tf.font = .systemFont(ofSize: 20, weight: .semibold)
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.secondaryLabel.cgColor
        tv.layer.cornerRadius = 8
        tv.isScrollEnabled = false
        return tv
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            saveIfNeeded()
        }
    }

    // MARK: - TodoDetailsViewInput
    
    func configure(with todo: Todo?) {
        if let todo = todo {
            titleTextField.text = todo.title
            descriptionTextView.text = todo.details
            dateLabel.text = formatDate(todo.createdAt)
            navigationItem.title = todo.title
        } else {
            dateLabel.text = formatDate(Date())
            navigationItem.title = "Новая задача"
        }
    }
}

// MARK: - Private UI Setup
private extension TodoDetailsViewController {

    func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupScrollStack()
    }

    func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }

    func setupScrollStack() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(titleTextField)
        contentStack.addArrangedSubview(dateLabel)
        contentStack.addArrangedSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func saveIfNeeded() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let description = descriptionTextView.text
        output.didTapSave(title: title, description: description)
    }
}
