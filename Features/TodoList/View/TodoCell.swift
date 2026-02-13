//
//  TodoCell.swift
//  EffectiveMobile_TodoList
//
//  Created by Mikhail Egorov on 13.02.2026.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    private let checkboxButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let textStack = UIStackView()
    private let containerStack = UIStackView()
    
    var onToggle: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public methods
    
    func configure(with todo: Todo) {
        
        dateLabel.text = formatDate(todo.createdAt)
        
        descriptionLabel.isHidden = todo.details?.isEmpty ?? true
        descriptionLabel.text = todo.details
        
        if todo.isCompleted {
            
            checkboxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkboxButton.tintColor = .systemOrange
            
            let attributed = NSAttributedString(
                string: todo.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
            
            titleLabel.attributedText = attributed
            descriptionLabel.textColor = .secondaryLabel
            
        } else {
            
            checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkboxButton.tintColor = .secondaryLabel
            
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
            titleLabel.textColor = .label
            
            descriptionLabel.textColor = .label
        }
    }
    
    // MARK: - Private methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    @objc private func toggleTapped() {
        onToggle?()
    }
}

// MARK: - Setup UI

private extension TodoCell {
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.isUserInteractionEnabled = true
        checkboxButton.addTarget(self,
                                 action: #selector(toggleTapped),
                                 for: .touchUpInside)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.addArrangedSubview(dateLabel)
        
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .top
        
        containerStack.addArrangedSubview(checkboxButton)
        containerStack.addArrangedSubview(textStack)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

