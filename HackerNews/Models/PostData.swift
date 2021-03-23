//
//  PostData.swift
//  HackerNews
//
//  Created by Violetta Bordovich on 2/11/21.
//  Copyright © 2021 Arseni. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
