//
//  WebView.swift
//  HackerNews
//
//  Created by Violetta Bordovich on 2/12/21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString {
            if let url = URL(string: safeString) {
            let request = URLRequest(url: url)
            uiView.load(request)
            }
        }
    }
}
