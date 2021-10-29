//
//  ContentView.swift
//  HackerNews
//
//  Created by Arseni Laputska on 2/10/21.
//  Copyright © 2021 Arseni. All rights reserved.
//
//
//import SwiftUI
//
//struct ContentView: View {
//
//    @ObservedObject var networkManager = NetworkManager()
//
//    var body: some View {
//        NavigationView {
//            List(networkManager.posts) { post in
//                NavigationLink(destination: DetailView(url: post.url)) {
//                    HStack {
//                        Text(String(post.points))
//                        Text(post.title)
//                    }
//                }
//            }
//            .navigationBarTitle("HackerNews")
//        }
//        .onAppear {
//            self.networkManager.fetchData()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
