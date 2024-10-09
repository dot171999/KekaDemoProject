//
//  CoreDataStack.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import CoreData

struct CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    
    static var preview: CoreDataStack = {
        let result = CoreDataStack(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "KekaDemoProject")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveArticles(_ articles: [Article]) {
        do {
            for article in articles {
                let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id = %@", article.id)
                
                let count = try container.viewContext.count(for: fetchRequest)
                
                if count == 0 {
                    let entity = ArticleMO(context: container.viewContext)
                    entity.date = article.timeStamp
                    entity.desc = article.desc
                    entity.title = article.headline.main
                    entity.id = article.id
                }
            }
            print("articles saved")
            try container.viewContext.save()
        } catch {
            print("Failed to save articles: \(error)")
        }
    }
    
    func fetchSavedArticles() -> [Article] {
        let request: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let entities = try container.viewContext.fetch(request)
            return entities.map { Article(id: $0.id ?? "NA",
                                          headline: Headline(main: $0.title ?? "NA"),
                                          desc: $0.desc ?? "NA",
                                          timeStamp: $0.date ?? "NA",
                                          multimedia: []) }
        } catch {
            print("Failed to fetch articles: \(error)")
            return []
        }
    }
    
    func saveArticleImageData(id: String, imageData: Data) {
        let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let entities = try container.viewContext.fetch(fetchRequest)
            
            if let articleMO = entities.first, articleMO.image == nil {
                articleMO.image = imageData
                try container.viewContext.save()
                
            }
        } catch {
            print("Failed to set image data in article: \(error)")
        }
    }
    
    func loadImageDataforArticle(id: String) -> Data? {
        let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let entities = try container.viewContext.fetch(fetchRequest)
            
            if let articleMO = entities.first {
                
                print("image loaded from coredata id ", id)
                return articleMO.image
            } else {
                print("image for Article with id \(id) not found in coredadta.")
                return nil
            }
        } catch {
            print("Failed to fetch image data in article coredata: \(error)")
            return nil
        }
    }
}
