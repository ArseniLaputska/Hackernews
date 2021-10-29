//
//  PostedBy.swift
//  HackerNews
//
//  Created by Arseni Laputska on 27.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import SwiftUI

struct PostedBy: View {
  let time: TimeInterval
  let currentDate: Date
  
  private static var relativeFormatter = RelativeDateTimeFormatter()
  
  private var relativeTimeString: String {
    return PostedBy.relativeFormatter.localizedString(fromTimeInterval: time - self.currentDate.timeIntervalSince1970)
  }
  
    var body: some View {
        Text("\(relativeTimeString)")
          .font(.headline)
          .foregroundColor(.gray)
    }
}

struct PostedBy_Previews: PreviewProvider {
    static var previews: some View {
      PostedBy(time: Date().timeIntervalSince1970, currentDate: Date())
    }
}
