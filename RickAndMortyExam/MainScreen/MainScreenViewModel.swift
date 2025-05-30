//
//  ViewModel.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation
import Combine

class MainScreenViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    private let apiService: ApiServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    var allCharacters: [DisplayableCharacter] = []
    
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchCharacters() {
        guard !isLoading, currentPage <= totalPages else { return }
        
        state = .loading
        isLoading = true
        
        Task {
            do {
                let response  = try await apiService.fetchApiResponse(page: currentPage)
                totalPages = response.info.pages
                currentPage += 1
                isLoading = false
                let characters  = toDisplayableCharacters(characters: response.results)
                allCharacters.append(contentsOf: characters)
                await MainActor.run {
                    state = .success(allCharacters)
                }
            } catch {
                isLoading = false
                await MainActor.run{
                    state = .error(error)
                }
            }
        }
    }
    
    private func toDisplayableCharacters(characters: [Character]) -> [DisplayableCharacter] {
        let displayableCharacters: [DisplayableCharacter] = characters.compactMap { character in
            guard let name = character.name,
                  let status = character.status,
                  let species = character.species,
                  let gender = character.gender,
                  let image = character.image
            else { return nil}
            return DisplayableCharacter(id: character.id, name: name, status: status, species: species, gender: gender, image: image)
        }
        return displayableCharacters
    }
    
}


enum ViewState {
    case loading
    case success([DisplayableCharacter])
    case error(Error)
}
