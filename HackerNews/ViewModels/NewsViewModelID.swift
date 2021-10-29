//
//  NewsViewModelID.swift
//  HackerNews
//
//  Created by Arseni Laputska on 27.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import Foundation
import Combine
import SwiftySound

class NewsViewModelID: ObservableObject {
  private let api = HackerNewsAPI.shared
  //input
  @Published var indexEndpoint: Int = 0
  @Published var currentDate = Date()
  //output
  @Published var stories = [Story]()
  
  private var oldIds = [Int]()
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    Publishers.CombineLatest( $currentDate, $indexEndpoint )
      .flatMap { (time, indexEndpoint) -> AnyPublisher<[Int], Never> in
        self.api.storyIDs(from: Endpoint(index: indexEndpoint)!)
          .map { (currentIds) in
            let ids = Array(currentIds.prefix(self.api.maxStories))
            
            if self.oldIds.count == 0 || ids.first! != self.oldIds.first! {
              self.oldIds = ids
              return ids
            } else { return [Int()] }
          }
          .eraseToAnyPublisher()
      }
      .flatMap { storyIds -> AnyPublisher<[Story], Never> in
        self.api.mergedStories(ids: storyIds)
          .collect()
          .catch { _ in Empty() }
          .filter { !$0.isEmpty }
          .map { stories in stories.sorted(by: {$0.id > $1.id}) }
          .eraseToAnyPublisher()
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { (stories) in
        if stories.count > 0 {
          Sound.play(file: "success.wav")
          self.stories = stories
        }
      })
      .store(in: &self.subscriptions)
  }
  
  deinit {
    Sound.stopAll()
  }
}
