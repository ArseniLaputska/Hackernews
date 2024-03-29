//
//  NewsViewModel.swift
//  HackerNews
//
//  Created by Arseni Laputska on 27.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import Foundation
import Combine
import SwiftySound

class NewsViewModel: ObservableObject {
  private let api = HackerNewsAPI.shared
  
  //input
  @Published var indexEndpoint: Int = 0
  @Published var currentDate = Date()
  //output
  @Published var stories = [Story]()
  
  private var oldStories = [Story]()
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    Publishers.CombineLatest($currentDate, $indexEndpoint)
      .flatMap { (_, indexEndpoint) -> AnyPublisher<[Story], Never> in
        self.api.stories(from: Endpoint(index: indexEndpoint)!)
      }
      .receive(on: RunLoop.main)
      .sink(receiveValue: { (stories) in
        let oldIds = self.oldStories.sorted(by: { $0.id > $1.id }).map { $0.id }
        let currentIds = stories.sorted(by: { $0.id > $1.id }).map { $0.id }
        
        if oldIds.count == 0 || currentIds.first! != oldIds.first! {
          Sound.play(file: "succes.wav")
          self.stories = stories.sorted(by: { $0.id > $1.id })
          self.oldStories = stories.sorted(by: { $0.id > $1.id })
        }
      })
      .store(in: &self.subscriptions)
  }
  
  deinit {
    Sound.stopAll()
  }
}
