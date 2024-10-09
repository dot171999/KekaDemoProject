//
//  ArticleViewModel.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation
import UIKit

extension ArticleView {
    @Observable
    class ViewModel {
        
        private let articleService: ArticleServiceProtocol
        var image: UIImage?
        
        init(articleService: ArticleServiceProtocol = ArticleService()) {
            self.articleService = articleService
        }
        
        func loadImage(from url: String, for articleId: String) async {
            guard image == nil else { return }
            
            if let data = await articleService.loadImageDataforArticle(id: articleId) {
                image = UIImage(data: data)
            } else {
                do {
                    if let data = try await articleService.getAndSaveImageData(from: url, for: articleId) {
                        image = UIImage(data: data)
                    }
                } catch {
                    
                }
            }
        }
    }
}
