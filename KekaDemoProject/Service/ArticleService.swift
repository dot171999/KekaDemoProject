//
//  ArticleService.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation
import CoreData

class ArticleService: ArticleServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchArticles() async throws -> [Article] {
        guard let url = URL(string: APIEndpoint.Get.articles) else {
            return []
        }
        
        do {
            let response: ArticleSearch = try await networkManager.getModel(from: url)
            let articles = response.response.docs.sorted { $0.timeStamp > $1.timeStamp }
            
            CoreDataStack.shared.saveArticles(articles)
            
            return articles
        } catch {
            return CoreDataStack.shared.fetchSavedArticles()
        }
    }
    
    func loadImageData(from url: String, id: String) async throws -> Data? {
        guard let url = URL(string: "https://static01.nyt.com/" + url) else {
            return nil
        }
        
        do {
            let dataResponse = try await networkManager.getData(from: url)
            
            DispatchQueue.main.async {
                CoreDataStack.shared.saveArticleImageData(id: id, imageData: dataResponse)
            }
            return dataResponse
        } catch {
            
            return nil
        }
    }
}
