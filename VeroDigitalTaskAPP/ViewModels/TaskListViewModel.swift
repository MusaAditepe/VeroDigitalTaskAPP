//
//  TaskListViewModel.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import Foundation

class TaskListViewModel {
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    
    var onTasksUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var numberOfTasks: Int {
        return filteredTasks.count
    }
    
    init() {
        loadSavedTasks()
    }
    
    private func loadSavedTasks() {
        let savedTasks = CoreDataManager.shared.fetchTasks()
        if !savedTasks.isEmpty {
            self.tasks = savedTasks
            self.filteredTasks = savedTasks
            DispatchQueue.main.async { [weak self] in
                self?.onTasksUpdated?()
            }
        }
    }
    
    func task(at index: Int) -> Task {
        return filteredTasks[index]
    }
    
    func fetchTasks() {
        NetworkManager.shared.authenticate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchTasksList()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchTasksList() {
        NetworkManager.shared.fetchTasks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                self.filteredTasks = tasks
                CoreDataManager.shared.saveTasks(tasks)
                DispatchQueue.main.async {
                    self.onTasksUpdated?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func searchTasks(with query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                let mirror = Mirror(reflecting: task)
                return mirror.children.contains { child in
                    guard let value = child.value as? String else { return false }
                    return value.lowercased().contains(query.lowercased())
                }
            }
        }
        onTasksUpdated?()
    }
    
    func updateSearchQuery(with scannedText: String) {
        searchTasks(with: scannedText)
    }
}
