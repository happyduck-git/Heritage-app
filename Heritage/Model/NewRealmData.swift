//
//  RealmData.swift
//  Heritage
//
//  Created by HappyDuck on 2022/03/26.
//

import Foundation
import RealmSwift

class NewRealmData: Object {
    @objc dynamic var userName: String = "user"
    @objc dynamic var pw: String = "1234"
    @objc dynamic var sector: String = "sector"
    @objc dynamic var title: String = "title"
    @objc dynamic var comment: String = "comment"
    @objc dynamic var likeCount: Int = 0
    @objc dynamic var done: Bool = false
}
