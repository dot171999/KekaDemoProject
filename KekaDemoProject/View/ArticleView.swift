//
//  ArticleView.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import SwiftUI

struct ArticleView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var viewModel = ViewModel()
    let article: Article
    
    var body: some View {
        VStack (alignment: .leading) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.white)
            Text(article.headline.main)
                .font(.headline)
            HStack {
                
                VStack (alignment: .leading) {
                    Text(article.readAbleDate())
                    
                        .padding(.bottom)
                    Text(article.desc)
                }
                Spacer()
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                    
                } else {
                    Rectangle()
                        .frame(width: 100, height: 100)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colorScheme == .dark ? .black : .white)
        .clipShape(.rect(cornerRadius: 10))
        .task {
            await viewModel.loadImage(from: article.multimedia.first?.url ?? "", for: article.id)
        }
    }
}

