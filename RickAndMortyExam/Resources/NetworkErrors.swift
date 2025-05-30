//
//  NetworkErrors.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case DecodingFailure
    case UnknownError
}
