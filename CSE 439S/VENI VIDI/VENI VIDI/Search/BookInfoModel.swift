//
//  BookInfoModel.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/3/15.
//
import Foundation

// MARK: - BookError

enum BookError: Error {
    case noDataAvailable
    case failProcessData
}

// MARK: - BookRequest

struct BookRequest {
    let resourceURL: URL

    init(with word: String) {
        let urlString = NSURLComponents(string: "https://www.googleapis.com/books/v1/volumes")
        urlString?.queryItems = [URLQueryItem(name: "q", value: word)]
        guard let requestURL = urlString?.url?.absoluteURL else {
            fatalError()
        }

        resourceURL = requestURL
    }

    func getBooks(completion: @escaping (Result<[Volume], BookError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(VolumeResponse.self, from: jsonData)
                let volumes = response.items
                completion(.success(volumes))
            } catch {
                completion(.failure(.failProcessData))
            }
        }
        dataTask.resume()
    }
}

// MARK: - ImageInfo

struct ImageInfo: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}

// MARK: - VolumeInfo

struct VolumeInfo: Decodable {
    let title: String
    let imageLinks: ImageInfo
}

// MARK: - Volume

struct Volume: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

// MARK: - VolumeResponse

struct VolumeResponse: Decodable {
    let kind: String
    let totalItems: Int
    let items: [Volume]
}
