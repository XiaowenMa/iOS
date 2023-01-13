//
//  TMDBTVSearchAgent.swift
//  VENI VIDI
//
//  Created by 雲無心 on 4/13/21.
//

import Foundation
import UIKit

// MARK: - TMDBTVSearchAgent

class TMDBTVSearchAgent: DatabaseSearchAgent {
    // MARK: - Properties

    internal let agentType: QueryContentType = .tvShow

    private let searchUrl: String = "https://api.themoviedb.org/3/search/tv"
    private let itemUrl: String = "https://api.themoviedb.org/3/tv"
    private let apiKey: String = "29748b6586282540605ffb47f2378ad4"

    private let imageUrl500 = "https://image.tmdb.org/t/p/w500"
    private let imageUrlOriginal = "https://image.tmdb.org/t/p/original"

    // MARK: - DatabaseSpecificSearchAgent Query Function

    func query(withKeyword keyword: String,
               withTimeStamp timeStamp: TimeInterval,
               withCompletionHandler completionHandler: @escaping (Result<[QueryResult], QueryAgentError>) -> Void) {

        var urlComponents = URLComponents(string: searchUrl)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                     URLQueryItem(name: "query", value: keyword)]

        guard let requestURL = urlComponents?.url?.absoluteURL
        else { completionHandler(.failure(.urlError)); return }

        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, _ in
            guard let acquiredData = data else { completionHandler(.failure(.noData)); return }
            guard let parsedData = try? JSONDecoder().decode(TMDBTVQueryResults.self, from: acquiredData)
            else { completionHandler(.failure(.cannotDecodeData)); return }

            let queriedTVShows = parsedData.results
            var queryResults: [QueryResult] = []

            for tvShow in queriedTVShows {
                var result = QueryResult(withTVStruct: tvShow, withTimeStamp: timeStamp)
                result.coverUrl = tvShow.poster_path != nil ? self.imageUrl500 + tvShow.poster_path! : nil
                queryResults.append(result)
            }

            completionHandler(.success(queryResults))
        }

        dataTask.resume()
    }

    // MARK: - Helper Function

    func retriveCoverImage(withPosterPath posterPath: String?) -> UIImage? {
        if let path = posterPath {
            let imageUrl = URL(string: imageUrl500 + path)
            let data = try? Data(contentsOf: imageUrl!)
            return UIImage(data: data!)
        } else {
            return nil
        }
    }
}

// MARK: DatabaseRecommendationAgent

extension TMDBTVSearchAgent: DatabaseRecommendationAgent {

    // MARK: - Recommendation Function

    func getRandomRecommendation(withDataStack coreDataStack: CoreDataStack = CoreDataStack(),
                                 withCompletionHandler completionHandler:
                                 @escaping (Result<[QueryResult], QueryAgentError>) -> Void) {

        let dataService = DataService(coreDataStack: coreDataStack)
        let seed = dataService.fetchAllJournalEntries(withType: agentType)?.randomElement()

        guard let seedEntry = seed else { completionHandler(.failure(.noData)); return }
        guard let seedTitle = seedEntry.worksTitle else { completionHandler(.failure(.noData)); return }

        var seedTMDBId: Int?
        let timeStamp = Date().timeIntervalSince1970
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        query(withKeyword: seedTitle, withTimeStamp: timeStamp) { result in

            switch result {
            case let .success(seedQueryResult):
                if let seedId = seedQueryResult.first?.tmdbId {
                    seedTMDBId = seedId
                    dispatchGroup.leave()
                } else {
                    completionHandler(.failure(.noData))
                    return
                }

            case let .failure(error):
                completionHandler(.failure(error))
                return
            }
        }

        dispatchGroup.wait()

        guard let seedId = seedTMDBId else { completionHandler(.failure(.noData)); return }
        var urlComponents = URLComponents(string: itemUrl + "/\(seedId)/similar")
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let requestURL = urlComponents?.url?.absoluteURL else { completionHandler(.failure(.urlError)); return }

        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, _ in

            guard let acquiredData = data else { completionHandler(.failure(.noData)); return }
            guard let parsedData = try? JSONDecoder().decode(TMDBTVQueryResults.self, from: acquiredData)
            else { completionHandler(.failure(.cannotDecodeData)); return }

            let queriedTVShows = parsedData.results
            var queryResults: [QueryResult] = []
            for tvShow in queriedTVShows {
                var result = QueryResult(withTVStruct: tvShow, withTimeStamp: timeStamp)
                result.coverUrl = tvShow.poster_path != nil ? self.imageUrl500 + tvShow.poster_path! : ""
                result.description = tvShow.overview
                queryResults.append(result)
            }
            completionHandler(.success(queryResults))
        }
        dataTask.resume()
    }
}
