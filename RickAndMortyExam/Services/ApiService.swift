//
//  ApiService.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation

class ApiServiceImpl: ApiServiceProtocol {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func fetchApiResponse(page: Int) async throws -> Response {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)") else {
            throw NetworkErrors.invalidURL
        }
        
        do {
            let (data,_) = try await session.data(from: url)
            let decodedResponse = try decoder.decode(Response.self, from: data)
            return decodedResponse
        } catch _ as DecodingError {
            throw NetworkErrors.DecodingFailure
        } catch {
            throw NetworkErrors.UnknownError
        }
    }
}
