//
//  ContentViewModel.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import Foundation

extension ContentView {
    @Observable
    final class ViewModel {
        var articles: [Article] = []
        
        private let articleService: ArticleServiceProtocol
        
        init(articleService: ArticleServiceProtocol = ArticleService()) {
            self.articleService = articleService
        }
        
        func fetchArticles() async {
            do {
                let articles = try await articleService.fetchArticles()
                self.articles = articles
            } catch {
                print("Error: ", error.localizedDescription)
            }
        }
    }
}
