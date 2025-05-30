//
//  Character.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String?
    let status: String?
    let species: String?
    let gender: String?
    let image: String?
}
