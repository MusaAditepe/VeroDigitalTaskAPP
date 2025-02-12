//
//  TaskTableViewCell.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(colorView)
        contentView.addSubview(taskLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 16),
            colorView.heightAnchor.constraint(equalToConstant: 16),
            
            taskLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 16),
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.leadingAnchor.constraint(equalTo: taskLabel.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: taskLabel.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: taskLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: taskLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with task: Task) {
        taskLabel.text = task.task
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        
        if let colorCode = task.colorCode {
            colorView.backgroundColor = UIColor(hex: colorCode)
        } else {
            colorView.backgroundColor = .gray
        }
    }
}

