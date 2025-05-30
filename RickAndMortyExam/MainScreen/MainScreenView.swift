//
//  MainScreenview.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation
import UIKit
import Combine

class MainScreenView: UIViewController {
    
    private var characters: [DisplayableCharacter] = []
    private let viewModel: MainScreenViewModel
    private var cancellables: Set<AnyCancellable> = []
    private let imageService: ImageServiceProtocol
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private lazy var loader:  UIActivityIndicatorView = {
        var loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    init(viewModel: MainScreenViewModel, imageService: ImageServiceProtocol) {
        self.viewModel = viewModel
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        observeViewModel()
        setupLoader()
        viewModel.fetchCharacters()
        
    }
    
    private func setupLoader() {
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showloader() {
        loader.startAnimating()
    }
    
    private func hideLoader() {
        loader.stopAnimating()
    }
    
    private func showCharacters(_ characters: [DisplayableCharacter]) {
        self.characters = characters
        tableView.reloadData()
    }
    
    private func showError(_ error : Error) {
        let alertMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertMessage, animated: true)
    }
    
    private func observeViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading: showloader()
                case .error(let error):
                    hideLoader()
                    showError(error)
                case .success(let characters):
                    hideLoader()
                    showCharacters(characters)
                }
            }
            .store(in: &cancellables)
    }
}

extension MainScreenView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configureInfo(character: character, imageService: imageService)
        
        if indexPath.row == characters.count - 1 {
            viewModel.fetchCharacters()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCharacter = characters[indexPath.row]
        let detailsScreen = DetailsScreen(character: selectedCharacter, imageService: imageService)
        navigationController?.pushViewController(detailsScreen, animated: true)
    }
}
