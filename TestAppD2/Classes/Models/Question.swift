//
//  Question.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

struct Question: Decodable {
    let items: [Item]?
}

struct Item: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case owner
        case answerCount = "answer_count"
        case questionId = "question_id"
        case lastActivityDate = "last_activity_date"
        case title
    }
    
    let owner: Owner?
    let answerCount: Int?
    let questionId: Int?
    let lastActivityDate: Int?
    let title: String?
    var smartDateFormat: String? {
        if let lastDataValue = lastActivityDate, let timeInterval = TimeInterval(exactly: lastDataValue) {
            return Item.timeAgoString(from: Date(timeIntervalSince1970: timeInterval))
        } else {
            return Item.timeAgoString(from: Date())
        }
    }

    static func timeAgoString(from date: Date?) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        let now = Date()
        let calendar = Calendar.current
        var components: DateComponents
        if let aDate = date {
            components = calendar.dateComponents(
                [.year, .month, .weekOfMonth, .day, .hour, .minute, .second],
                from: aDate,
                to: now
            )
            if let yearComponents = components.year, yearComponents > 0 {
                formatter.allowedUnits = NSCalendar.Unit.year
            } else if let monthComponents = components.month, monthComponents > 0 {
                formatter.allowedUnits = .month
            } else if let weekComponents = components.weekOfMonth, weekComponents > 0 {
                formatter.allowedUnits = .weekOfMonth
            } else if let dayComponents = components.day, dayComponents > 0 {
                formatter.allowedUnits = .day
            } else if let hourComponents = components.hour, hourComponents > 0 {
                formatter.allowedUnits = .hour
            } else if let minuteComponents = components.minute, minuteComponents > 0 {
                formatter.allowedUnits = .minute
            } else {
                formatter.allowedUnits = .second
            }
            return "  \(formatter.string(from: components) ?? "") ago"
        }
        return ""
    }
}

struct Owner: Decodable {
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
            case displayName = "display_name"
    }
}
