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
        private let articleService: ArticleServiceProtocol
        private(set) var articles: [Article] = []
        private(set) var isLoading: Bool = false
        
        init(articleService: ArticleServiceProtocol = ArticleService()) {
            self.articleService = articleService
        }
        
        func loadArticles() async {
            isLoading = true
            do {
                self.articles = try await articleService.getAndSaveArticles(from: APIEndpoint.Get.articles.urlString)
                
            } catch {
                self.articles = articleService.loadSavedArticles()
            }
            isLoading = false
        }
    }
}
