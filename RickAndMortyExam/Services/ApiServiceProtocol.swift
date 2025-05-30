//
//  ApiServiceProtocol.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation

protocol ApiServiceProtocol {
    func fetchApiResponse(page: Int) async throws -> Response
}

