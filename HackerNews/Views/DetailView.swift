//
//  DetailView.swift
//  HackerNews
//
//  Created by Arseni Laputska on 2/12/21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    let url: URL?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
      DetailView(url: URL(string:"https://www.google.com")!)
    }
}
