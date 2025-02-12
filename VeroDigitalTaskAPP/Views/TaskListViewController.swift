//
//  TaskListViewController.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import UIKit
import AVFoundation

class TaskListViewController: UIViewController {
    private let viewModel = TaskListViewModel()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search..."
        return controller
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchTasks()
    }
    
    private func setupUI() {
        title = "Tasks"
        view.backgroundColor = .systemBackground
        
        // Navigation Bar Setup
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // QR Code Scanner Button
        let scanButton = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(scanQRCodeTapped))
        navigationItem.rightBarButtonItem = scanButton
        
        // TableView Setup
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Pull to Refresh
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Search Controller
        searchController.searchResultsUpdater = self
    }
    
    private func setupBindings() {
        viewModel.onTasksUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Error",
                                        message: error,
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okey", style: .default))
            self?.present(alert, animated: true)
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func refreshData() {
        viewModel.fetchTasks()
    }
    
    @objc private func scanQRCodeTapped() {
        checkCameraPermission()
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentQRScanner()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.presentQRScanner()
                    }
                }
            }
        default:
            showCameraPermissionAlert()
        }
    }
    
    private func presentQRScanner() {
        let scannerVC = QRScannerViewController { [weak self] result in
            self?.searchController.searchBar.text = result
            self?.viewModel.updateSearchQuery(with: result)
        }
        present(scannerVC, animated: true)
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "Camera permission is required for QR code scanning. Please enable camera permission in settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = viewModel.task(at: indexPath.row)
        cell.configure(with: task)
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.searchTasks(with: query)
    }
}
