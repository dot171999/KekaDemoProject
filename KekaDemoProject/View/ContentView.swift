//
//  ContentView.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach (viewModel.articles) { article in
                    ArticleView(article: article)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)
        }
        .task {
            await viewModel.fetchArticles()
        }
        .navigationTitle("Articles")
        .background(.gray)
    }
}

