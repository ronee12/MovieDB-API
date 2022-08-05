//
//  MovieServiceManager.swift
//  Movie DB API
//
//  Created by Mehedi Hasan on 5/8/22.
//

import Foundation
import UIKit

protocol MovieServiceInteractor {
    func getMovieList(with searchText: String, completion: @escaping (Result<MovieServiceResponse, MovieServiceError>) -> Void)
}

struct MovieService: Decodable {
    let id: Int
    let originalTitle: String?
    let overview: String?
    let posterUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, overview
        case originalTitle = "original_title"
        case posterUrl = "poster_path"
    }
}

struct MovieServiceResponse: Decodable {
    let results: [MovieService]
    let page: Int
}

enum MovieServiceError: Error, LocalizedError {
    case urlParsingError
    case responseError(Error)
    case dataNilError
    case decodeError
    
    var errorDescription: String? {
        switch self {
        case .urlParsingError:
            return "Could not parse from string to URL"
        case .responseError(let error):
            return "Data fetching is failed with error \(error.localizedDescription)"
        case .dataNilError:
            return "Fetched data is nil"
        case .decodeError:
            return "Could not parse response data"
        }
    }
    
}

class MovieServiceManager {
    
    let apiKey: String = "38e61227f85671163c275f9bd95a8803"
    let baseUrl: String = "https://api.themoviedb.org/3/search/movie"
    
    var cacheImage = NSCache<AnyObject, AnyObject>()
    
    init() {
    }
    
    func loadWith(imageUrl: String, completion: @escaping (Result<UIImage, MovieServiceError>) -> Void) {
        
        let baseUrl: String = "https://image.tmdb.org/t/p/w185/"
        let apiKey: String = "198b78b4f51aa9884d1bfdb61818f22c"
        
        let fullUrlString = "\(baseUrl)\(imageUrl)?api_key=\(apiKey)"
        
        let data = cacheImage.object(forKey: imageUrl as AnyObject) as? Data
        
        if let data = data, let image = UIImage(data: data) {
            completion(.success(image))
            return
        }
        
        
        guard let fullUrl = URL(string: fullUrlString) else {
            completion(.failure(.urlParsingError))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: fullUrl) { [weak self] (data, respons, error) in
            
            if let error = error {
                completion(.failure(.responseError(error)))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.dataNilError))
                return
            }
            
            self?.cacheImage.setObject(data as AnyObject, forKey: imageUrl as AnyObject)
            completion(.success(image))
        }
        dataTask.resume()
    }
    
}

extension MovieServiceManager: MovieServiceInteractor {
    func getMovieList(with searchText: String, completion: @escaping (Result<MovieServiceResponse, MovieServiceError>) -> Void) {
        
        var urlComponent = URLComponents(string: baseUrl)
        let queryItem = URLQueryItem(name: "query", value: searchText)
        let apiKeyItem = URLQueryItem(name: "api_key", value: apiKey)
        urlComponent?.queryItems = [apiKeyItem, queryItem]
        
        print("full url \(String(describing: urlComponent?.url?.absoluteString))")
        
        guard let url = urlComponent?.url else {
            completion(.failure(.urlParsingError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.responseError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNilError))
                return
            }
            
            guard let movieData = try? JSONDecoder().decode(MovieServiceResponse.self, from: data) else {
                print("could not decode")
                completion(.failure(.decodeError))
                return
            }
            
            print("Fetched movie count \(movieData.results.count)")
            completion(.success(movieData))
            return
        }.resume()
    }
}
