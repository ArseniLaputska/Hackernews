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
  
  
  func story(id: Int) -> AnyPublisher<Story, Never> {
    URLSession.shared.dataTaskPublisher(for: Endpoint.story(id).url)
      .map { $0.0 }
      .decode(type: Story.self, decoder: JSONDecoder())
      .catch { _ in Empty() }
      .eraseToAnyPublisher()
  }
  
  func storyIDs(from endpoint: Endpoint) -> AnyPublisher<[Int], Never> {
    URLSession.shared.dataTaskPublisher(for: endpoint.url)
      .map { $0.0 }
      .decode(type: [Int].self, decoder: JSONDecoder())
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
