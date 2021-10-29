//
//  HackerNewsAPI.swift
//  HackerNews
//
//  Created by Arseni Laputska on 26.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import Foundation
import Combine

enum Endpoint {
  static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
  
  case newstories, topstories, beststories
  case story(Int)
  
  var url: URL {
    switch self {
    case .newstories:
      return Endpoint.baseURL.appendingPathComponent("newstories.json") // latest news
    case .topstories:
      return Endpoint.baseURL.appendingPathComponent("topstories.json")
    case .beststories:
      return Endpoint.baseURL.appendingPathComponent("beststories.json")
    case .story(let id):
      return Endpoint.baseURL.appendingPathComponent("item/\(id).json")
    }
  }
  
  init? (index: Int) {
    switch index {
    case 0:
      self = .newstories
    case 1:
      self = .topstories
    case 2:
      self = .beststories
    default:
      return nil
    }
  }
}

class HackerNewsAPI {
  static let shared = HackerNewsAPI()
  
  //Maximum number of stories to fetch
  var maxStories = 10
  
  // Async fetch with URL
  func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.0 }
      .decode(type: T.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func story(id: Int) -> AnyPublisher<Story, Never> {
    fetch(Endpoint.story(id).url)
      .catch { _ in Empty() }
      .eraseToAnyPublisher()
  }
  
  func stories(from endpoint: Endpoint) -> AnyPublisher<[Story], Never> {
    fetch(endpoint.url)
      .catch { _ in Empty() }
      .filter { !$0.isEmpty }
      .flatMap { storyIDs in self.mergedStories(ids: storyIDs)}
      .collect(maxStories)
      .map { stories in  stories.sorted (by: {$0.id > $1.id})}
      .eraseToAnyPublisher()
  }
  
  func storyIDs(from endpoint: Endpoint) -> AnyPublisher<[Int], Never> {
    fetch(endpoint.url)
      .catch { _ in Empty() }
      .eraseToAnyPublisher()
  }
  
  func mergedStories(ids storyIDs: [Int]) -> AnyPublisher<Story, Never> {
    let storyIDs = Array(storyIDs.prefix(maxStories))
    precondition(!storyIDs.isEmpty)
    
    let initialPublisher = story(id: storyIDs[0])
    let remainder = Array(storyIDs.dropFirst())
    
    return remainder.reduce(initialPublisher) {
      (combined, id) -> AnyPublisher<Story, Never> in
      combined.merge(with: story(id: id))
        .eraseToAnyPublisher()
    }
  }
}
