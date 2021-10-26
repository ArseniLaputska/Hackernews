//
//  Story.swift
//  HackerNews
//
//  Created by Arseni Laputska on 26.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import Foundation

struct Story: Codable, Identifiable {
  let id: Int
  let title: String
  let by: String
  let time: TimeInterval
  let url: String
}

extension Story: CustomDebugStringConvertible {
  var debugDescription: String {
    return "-----\(id) \(title)\n"
  }
}
