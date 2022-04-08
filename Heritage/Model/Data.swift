//
//  Data.swift
//  Heritage
//
//  Created by HappyDuck on 2022/03/07.
//

import Foundation

struct Data: Codable {
    let boardNum: Int
    let userName: String
    let pw: String
    var sector: String
    var title: String
    var comment: String
    var likeCount: Int
//    var done: Bool
}
