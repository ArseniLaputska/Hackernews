//
//  BadgeTime.swift
//  HackerNews
//
//  Created by Arseni Laputska on 27.10.21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import SwiftUI

struct BadgeTime: View {
  private static var formatter: DateFormatter = {
    let timeFormat = DateFormatter()
    timeFormat.dateStyle = .none
    timeFormat.timeStyle = .short
    return timeFormat
  }()
  
  let time: TimeInterval
  
    var body: some View {
      Text(BadgeTime.formatter.string(from: Date(timeIntervalSince1970: time)))
        .font(.headline)
        .fontWeight(.heavy)
        .padding(10)
        .foregroundColor(Color.white)
        .background(Color.blue)
        .cornerRadius(6)
        .frame(idealWidth: 100)
        .padding(.bottom, 10)
    }
}

#if DEBUG
struct BadgeTime_Previews: PreviewProvider {
    static var previews: some View {
      BadgeTime(time: Date().timeIntervalSince1970)
    }
}
#endif
