//
//  NewsView.swift
//  HackerNews
//
//  Created by Arseni Laputska on 27.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import SwiftUI

struct NewsView: View {
  @ObservedObject var viewModel = NewsViewModel()
  
  private let timer = Timer.publish(every: 3, on: .main, in: .common)
    .autoconnect()
    .eraseToAnyPublisher()
  
    var body: some View {
      VStack {
        Text("HackerNews")
          .font(.largeTitle)
          .padding()
          .background(Color.blue)
        
        Picker("", selection: $viewModel.indexEndpoint) {
          Text("News").tag(0)
          Text("Top news").tag(1)
          Text("Best news").tag(2)
        }
        .background(Color.blue)
        .pickerStyle(SegmentedPickerStyle())
        
        List {
          ForEach(self.viewModel.stories) { story in
            HStack {
              BadgeTime(time: story.time)
              VStack {
                Text(story.title)
                  .font(.body)
                  .lineLimit(2)
                PostedBy(time: story.time, currentDate: self.viewModel.currentDate)
              }
            }
            .padding()
          }
        }
        .onReceive(timer) { self.viewModel.currentDate = $0 }
      } // VStack
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
