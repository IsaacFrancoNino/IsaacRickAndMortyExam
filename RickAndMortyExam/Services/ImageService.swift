//
//  Imageservicde.swift
//  RickAndMortyExam
//
//  Created by Trainee on 5/30/25.
//

import Foundation
import UIKit

class ImageServiceImpl: ImageServiceProtocol {
    
    private let session =  URLSession.shared
    
    func fetchImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw NetworkErrors.invalidURL }
        
        do {
            let (data,_) = try await session.data(from: url)
            guard let image = UIImage(data: data) else { throw NetworkErrors.DecodingFailure }
            return image
        } catch {
            throw NetworkErrors.UnknownError
        }
    }
}
