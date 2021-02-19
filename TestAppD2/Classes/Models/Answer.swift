//
//  Answer.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class Answer1: NSObject {
    var questionID: Int? = 0
    var body: String? = ""
    var author: String? = ""
    var numberOfVotes: Int? = 0
    var lastActivityDate: Date?
    var isAccepted: Bool? = false
}

class Answer: Decodable {
    var items: [AnswerItem]?
}

struct AnswerItem: Decodable {
    var owner: Owner?
    var score: Int?
    var lastActivityDate: Int?
    var body: String?
    var isAccepted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case owner
        case score
        case lastActivityDate = "last_activity_date"
        case body
        case isAccepted = "is_accepted"
    }
}
