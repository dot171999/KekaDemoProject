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
    private let coreDataStack: CoreDataProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(), coreDataStack: CoreDataProtocol = CoreDataStack.shared) {
        self.networkManager = networkManager
        self.coreDataStack = coreDataStack
    }
    
    func getAndSaveArticles(from urlString: String) async throws -> [Article] {
        guard let url = URL(string: urlString) else {
            return []
        }
        
        let articleSearch: ArticleSearch = try await networkManager.getModel(from: url)
        let articles = articleSearch.response.docs.sorted { $0.timeStamp > $1.timeStamp }
        
        try await save(articles, in: .background)
        
        return articles

    }
    
    func save(_ articles: [Article], in contextType: MOContext) async throws {
        let context = coreDataStack.context(for: contextType)
        
        try await context.perform { [weak self] in
            for article in articles {
                let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", article.id)
                
                let count = try context.count(for: fetchRequest)
                
                if count == 0 {
                    let entity = ArticleMO(context: context)
                    entity.date = article.timeStamp
                    entity.desc = article.desc
                    entity.title = article.headline.main
                    entity.id = article.id
                }
            }
            
            try self?.coreDataStack.save(context)
        }
    }
    
    func loadSavedArticles() -> [Article] {
        let context = coreDataStack.mainContext
        
        let request: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { Article(id: $0.id ?? "NA",
                                          headline: Headline(main: $0.title ?? "NA"),
                                          desc: $0.desc ?? "NA",
                                          timeStamp: $0.date ?? "NA",
                                          multimedia: []) }
        } catch {
            return []
        }
    }
    
    func getAndSaveImageData(from url: String, for articleId: String) async throws -> Data? {
        guard let url = URL(string: "https://static01.nyt.com/" + url) else {
            return nil
        }
        
        do {
            let dataResponse = try await networkManager.getData(from: url)
            
            try await saveArticleImageData(id: articleId, imageData: dataResponse)
            return dataResponse
        } catch {
            
            return nil
        }
    }
    
    func saveArticleImageData(id: String, imageData: Data) async throws {
        let context = coreDataStack.backgroundContext
        try await context.perform { [weak self] in
            let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            let entities = try context.fetch(fetchRequest)
            
            if let articleMO = entities.first, articleMO.image == nil {
                articleMO.image = imageData
                try self?.coreDataStack.save(context)
            }
        }
    }
    
    func loadImageDataforArticle(id: String) async -> Data? {
        let context = coreDataStack.backgroundContext
        
        return await context.perform {
            let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let entities = try context.fetch(fetchRequest)
                
                if let articleMO = entities.first, articleMO.image != nil {
                    return articleMO.image
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
    }
}
