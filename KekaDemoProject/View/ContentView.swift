//
//  ContentView.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach (viewModel.articles) { article in
                    ArticleView(article: article)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.horizontal)
        }
        .overlay{
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .tint(.red)
            }
        }
        .task {
            await viewModel.loadArticles()
        }
        .navigationTitle("Articles")
        .background(colorScheme == .dark ? .black : .gray)
    }
}


