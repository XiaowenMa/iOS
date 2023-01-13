//
//  SearchAgentProtocols.swift
//  VENI VIDI
//
//  Created by 雲無心 on 4/12/21.
//

import Foundation
import UIKit

// MARK: - DatabaseSearchAgent

protocol DatabaseSearchAgent {
    var agentType: QueryContentType { get }

    func query(withKeyword keyword: String,
               withTimeStamp timeStamp: TimeInterval,
               withCompletionHandler completionHandler: @escaping (Result<[QueryResult], QueryAgentError>) -> Void)
}

// MARK: - DatabaseRecommendationAgent

protocol DatabaseRecommendationAgent {

    func getRandomRecommendation(withDataStack coreDataStack: CoreDataStack,
                                 withCompletionHandler completionHandler:
                                 @escaping (Result<[QueryResult], QueryAgentError>) -> Void)
}
