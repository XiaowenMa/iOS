//
//  IGDBSearchAgent.swift
//  VENI VIDI
//
//  Created by 雲無心 on 3/29/21.
//

import Foundation
import UIKit

class IGDBSearchAgent: DatabaseSearchAgent {
    // MARK: - Properties

    internal var agentType: QueryContentType = .game

    private let clientID: String = "lvnmbqvnaakfxrprfxxt2pe6uosu0k"
    private let clientSecret: String = "gsxjvu9cpbr17jdy8b7weu9q8aae1v"
    private let gameSearchUrl: String = "https://api.igdb.com/v4/games"
    private let coverRequestUrl: String = "https://api.igdb.com/v4/covers"

    private var accessToken: String { updateAccessToken(); return "Bearer \(privateToken)" }
    private var privateToken: String = "" // the privately held access token without "Bearer" prefix
    private var accessTokenExpirationDate = Date()
    private let accessTokenRequestUrl: String = "https://id.twitch.tv/oauth2/token"
    private let accessTokenRevokeUrl: String = "https://id.twitch.tv/oauth2/revoke"

    private let candidateSize: Int = 5

    // MARK: - Destructor

    deinit {
        revokeAccessToken()
    }

    // MARK: - DatabaseSpecificSearchAgent Query Function

    func query(withKeyword keyword: String,
               withTimeStamp timeStamp: TimeInterval,
               withCompletionHandler completionHandler: @escaping (Result<[QueryResult], QueryAgentError>) -> Void) {

        guard let targetUrl = URL(string: gameSearchUrl) else { completionHandler(.failure(.urlError)); return }
        var urlRequest = URLRequest(url: targetUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.addValue(clientID, forHTTPHeaderField: "Client-iD")
        urlRequest.httpBody = Data("fields id,name,cover; search \"\(keyword)\";".utf8)

        var queriedGames: [IGDBDataStruct] = []

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in

            guard let acquiredData = data else { completionHandler(.failure(.noData)); return }
            guard let parsedData = try? JSONDecoder().decode([IGDBDataStruct].self, from: acquiredData)
            else { completionHandler(.failure(.cannotDecodeData)); return }

            queriedGames = parsedData
            dispatchGroup.leave()
        }

        dataTask.resume()
        dispatchGroup.wait()

        var queryResults: [QueryResult] = []
        if queriedGames.count > candidateSize {
            queriedGames = [IGDBDataStruct](queriedGames[..<candidateSize])
        }

        for game in queriedGames {

            var result = QueryResult(withIGDBStruct: game, withTimeStamp: timeStamp)

            guard let requestUrl = URL(string: coverRequestUrl) else { dispatchGroup.leave(); return }
            var urlRequest = URLRequest(url: requestUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
            urlRequest.addValue(clientID, forHTTPHeaderField: "Client-ID")
            urlRequest.httpBody = Data("fields url; where game = \(game.id);".utf8)

            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
                guard let acquiredData = data else { dispatchGroup.leave(); return }
                guard let parsedData =
                    try? JSONDecoder().decode([IGDBCoverRequestDataStruct].self, from: acquiredData).first
                else { dispatchGroup.leave(); return }
                result.coverUrl = parsedData.url
                dispatchGroup.leave()
            }

            dataTask.resume()
            dispatchGroup.wait()

            queryResults.append(result)
        }

        completionHandler(.success(queryResults))
    }

    // MARK: - Helper Functions for Access Token

    func updateAccessToken() {
        if accessTokenExpirationDate > Date() {
            return
        }

        revokeAccessToken()
        let accessTokenIssueRequest = IGDBAccessTokenIssueRequest(withClientID: clientID,
                                                                  withClientSecret: clientSecret)
        guard let targetUrl = URL(string: accessTokenRequestUrl)
        else { print("IGDBSearchAgent cannot generate URL from accessTokenRequestUrl"); return }
        var urlRequest = URLRequest(url: targetUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(accessTokenIssueRequest)

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [self] data, _, _ in
            guard let receivedData = data else { return }
            guard let parsedData = try? JSONDecoder().decode(IGDBAccessTokenResult.self,
                                                             from: receivedData) else { return }
            privateToken = parsedData.access_token
            accessTokenExpirationDate = Date(timeIntervalSinceNow: parsedData.expires_in)
            dispatchGroup.leave()
        }

        dataTask.resume()
        dispatchGroup.wait()
    }

    func revokeAccessToken() {
        var urlComponents = URLComponents(string: accessTokenRevokeUrl)
        urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: clientID),
                                     URLQueryItem(name: "token", value: "Bearer \(privateToken)")]

        guard let requestURL = urlComponents?.url?.absoluteURL else { return }
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, _, _ in }
        dataTask.resume()
    }
}
