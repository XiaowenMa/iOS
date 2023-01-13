//
//  QueryResult.swift
//  VENI VIDI
//
//  Created by 雲無心 on 4/12/21.
//

import Foundation
import UIKit

struct QueryResult {
    // MARK: - init from TMDB Movie Data Struct

    init(withMovieStruct movie: TMDBMovieDataStruct, withTimeStamp timeStamp: TimeInterval) {
        type = .movie
        title = movie.title
        tmdbId = movie.id
        self.timeStamp = timeStamp
    }

    // MARK: - init from TMDB TV Show Data Struct

    init(withTVStruct tvShow: TMDBTVDataStruct, withTimeStamp timeStamp: TimeInterval) {
        type = .tvShow
        title = tvShow.name
        tmdbId = tvShow.id
        self.timeStamp = timeStamp
    }

    // MARK: - init from IGBD Data Struct

    init(withIGDBStruct game: IGDBDataStruct, withTimeStamp timeStamp: TimeInterval) {
        type = .game
        title = game.name
        self.timeStamp = timeStamp
    }

    let type: QueryContentType
    let timeStamp: TimeInterval
    var tmdbId: Int?
    var title: String
    var coverUrl: String?
    var description: String = ""
}
