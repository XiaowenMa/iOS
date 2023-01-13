//
//  GeneralSearchAgent.swift
//  VENI VIDI
//
//  Created by 雲無心 on 3/29/21.
//

import Foundation

class GeneralSearchAgent {
    // MARK: - Properties

    private let searchAgents: [DatabaseSearchAgent] = [TMDBMovieSearchAgent(), TMDBTVSearchAgent(), IGDBSearchAgent()]
    private var results: [QueryContentType: [QueryResult]] = [:]

    internal lazy var coreDataStack = CoreDataStack()

    // MARK: - Search Function

    func query(withKeyword keyword: String,
               forContentType contentType: QueryContentType,
               withCompletionHandler completionHandler: @escaping (Result<[QueryResult], QueryAgentError>) -> Void) {

        query(withKeyword: keyword,
              forContentTypes: Set([contentType]),
              withCompletionHandler: completionHandler)
    }

    func query(withKeyword keyword: String,
               forContentTypes contentTypes: Set<QueryContentType> = Set([.book, .game, .movie, .tvShow]),
               withCompletionHandler completionHandler: @escaping (Result<[QueryResult], QueryAgentError>) -> Void) {

        for searchAgent in searchAgents {
            let agentType = searchAgent.agentType
            guard contentTypes.contains(agentType) else { continue }

            searchAgent.query(withKeyword: keyword,
                              withTimeStamp: Date().timeIntervalSince1970) { [self] result in

                switch result {
                case let .success(queryResult):
                    let prevTimeStamp = results[agentType]?.first?.timeStamp ?? TimeInterval.zero
                    if let newTimeStamp = queryResult.first?.timeStamp {
                        if prevTimeStamp < newTimeStamp {
                            results[agentType] = queryResult
                            completionHandler(.success(queryResult))
                        }
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    func getCurrentResults(forContentTypes contentTypes: Set<QueryContentType>?) -> [QueryContentType: [QueryResult]] {
        if let types = contentTypes {
            return results.filter { key, _ in types.contains(key) }
        }
        return results
    }

    func getRecommendation(forContentType contentType: QueryContentType,
                           withCompletionHandler completionHandler:
                           @escaping (Result<[QueryResult], QueryAgentError>) -> Void) {

        for searchAgent in searchAgents {
            guard contentType == searchAgent.agentType else { continue }
            guard let recommendationAgent = searchAgent as? DatabaseRecommendationAgent else { continue }

            recommendationAgent.getRandomRecommendation(withDataStack: coreDataStack,
                                                        withCompletionHandler: completionHandler)
        }
    }
}
