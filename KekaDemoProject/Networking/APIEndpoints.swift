//
//  APIEndpoints.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation

struct APIEndpoint {
    static let baseURL = "https://api.nytimes.com/"
    
    enum Get {
        case articles
        
        var urlString: String {
            switch self {
            case .articles:
                return "\(APIEndpoint.baseURL)svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM"
            }
        }
    }
}
