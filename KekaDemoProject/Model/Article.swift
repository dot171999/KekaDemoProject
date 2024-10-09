//
//  Article.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import Foundation

struct ArticleSearch: Decodable {
    let response: ArticleResponse
}

struct ArticleResponse: Decodable {
    let docs: [Article]
}

struct Article: Decodable, Identifiable {
    let id: String
    let headline: Headline
    let desc: String
    var timeStamp: String
        
    let multimedia: [Multimedia]

    enum CodingKeys: String, CodingKey {
        case id = "uri"
        case headline
        case desc = "abstract"
        case timeStamp = "pub_date"
        case multimedia
    }
    
    func readAbleDate() -> String {
        let dF1 = DateFormatter()
        dF1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dF2 = DateFormatter()
        dF2.dateFormat = "d MMMM, yyyy"
        
        if let date = dF1.date(from: timeStamp) {
            return dF2.string(from: date)
        } else {
            return ""
        }
    }
}

struct Headline: Codable {
    let main: String
}

struct Multimedia: Codable {
    let url: String
}
