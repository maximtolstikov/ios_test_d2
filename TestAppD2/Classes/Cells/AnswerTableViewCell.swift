//
//  AnswerTableViewCell.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var lastActivityDateLabel: UILabel!
    @IBOutlet private weak var numberOfVotesLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!
    
    func fill(_ answer: AnswerItem?, dateFormatter: DateFormatter) {
        backgroundColor = UIColor.white
        var answerBody = answer?.body
        let attributedString = NSMutableAttributedString(string: answer?.body ?? "")
        let pattern = "<code>[^>]+</code>"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex?.matches(in: answerBody ?? "", options: [], range: NSRange(location: 0, length: answerBody?.count ?? 0))
        for match in matches ?? [] {
            attributedString.addAttribute(
                .backgroundColor,
                value: UIColor(red: 0, green: 110.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.5),
                range: match.range
            )
            if let aSize = UIFont(name: "Courier", size: 17) {
                attributedString.addAttribute(.font, value: aSize, range: match.range)
            }
        }
        var cycle: Bool = true
        while cycle {
            if let aSearch = (answerBody as NSString?)?.range(of: "<[^>]+>", options: .regularExpression), aSearch.location != NSNotFound {
                attributedString.removeAttribute(.backgroundColor, range: aSearch)
                attributedString.replaceCharacters(in: aSearch, with: "\n")
                answerBody = (answerBody as NSString?)?.replacingCharacters(in: aSearch, with: "\n")
            } else {
                cycle = false
            }
        }
        answerLabel.attributedText = attributedString
        authorLabel.text = answer?.owner?.displayName
        numberOfVotesLabel.text = String(format: "%li", Int(answer?.score ?? 0))
        if let lastDateValue = answer?.lastActivityDate,
           let timeInterval = TimeInterval(exactly: lastDateValue) {
            lastActivityDateLabel.text = "\(dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval)))"
        }
        checkImageView.isHidden = answer?.isAccepted != nil
    }
    
}
