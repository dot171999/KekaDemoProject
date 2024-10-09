//
//  ArticleView.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import SwiftUI

struct ArticleView: View {
    @State var viewModel = ViewModel()
    let article: Article
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(article.headline.main)
                .font(.headline)
            HStack {
                
                VStack (alignment: .leading) {
                    Text(article.readAbleDate())
                    
                        .padding(.bottom)
                    Text(article.desc)
                }

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
        .background(.white)
        .clipShape(.rect(cornerRadius: 10))
        .task {
            await viewModel.loadImage(from: article.multimedia.first?.url ?? "", articleId: article.id)
        }
    }
}

#Preview {
    let article = Article(id:"123", headline: Headline.init(main: "HEADLINE ACNCKS KADNK dk"), desc: "Akjnd Akmfdsklfm Adkfskdf csdklfmskdffs skdfmskdlf sdlkmsddksdmdksdd skdmsdklm", timeStamp: "2024-10-07T16:16:02+0000", multimedia: [Multimedia(url: "images/2024/09/28/multimedia/28pol-poll-nebraska-promo-fqkw/28pol-poll-nebraska-promo-fqkw-articleLarge-v2.jpg")])
    return ArticleView(article: article)
}
