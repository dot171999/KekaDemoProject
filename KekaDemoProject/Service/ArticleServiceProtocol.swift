//
//  ArticleServiceProtocol.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation

protocol ArticleServiceProtocol: AnyObject {
    func fetchArticles() async throws -> [Article]
    func loadImageData(from url: String, id: String) async throws -> Data?
}
