//
//  DetailsScreen.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation
import UIKit

class DetailsScreen: UIViewController {
    private let character: DisplayableCharacter
    private var imageLoadTask: Task<Void, Never>?
    private let imageService: ImageServiceProtocol
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusLabel, speciesLabel, genderLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statusLabel = makeDetailLabel()
    private lazy var speciesLabel = makeDetailLabel()
    private lazy var genderLabel = makeDetailLabel()
    
    init(character: DisplayableCharacter, imageService: ImageServiceProtocol) {
        self.character = character
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureInfo()
    }
    
    private func setupUI() {
        view.addSubview(characterImageView)
        view.addSubview(nameLabel)
        view.addSubview(detailStack)
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 120),
            characterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            detailStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            detailStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureInfo() {
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status)"
        speciesLabel.text = "Species: \(character.species)"
        genderLabel.text = "Gender: \(character.gender)"
        
        imageLoadTask = Task {
            do {
                let image = try await imageService.fetchImage(from: character.image)
                await MainActor.run {
                    self.characterImageView.image = image
                }
            } catch {
                await MainActor.run {
                    self.characterImageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    
    private func makeDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
