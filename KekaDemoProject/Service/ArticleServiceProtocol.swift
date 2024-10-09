//
//  ArticleServiceProtocol.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation

protocol ArticleServiceProtocol: AnyObject {
    func getAndSaveArticles(from urlString: String) async throws -> [Article]
    func getAndSaveImageData(from url: String, for articleId: String) async throws -> Data?
    func save(_ articles: [Article], in contextType: MOContext) async throws
    func loadSavedArticles() -> [Article]
    func loadImageDataforArticle(id: String) async -> Data?
}
