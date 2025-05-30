//
//  ImageServiceProtocol.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
    func fetchImage(from urlString: String) async throws -> UIImage
}
