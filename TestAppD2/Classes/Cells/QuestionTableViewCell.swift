//
//  QuestionTableViewCell.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var dateModificationLabel: UILabel!
    @IBOutlet weak var numberOfAnswerLabel: UILabel!
    @IBOutlet weak var corneredView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        corneredView.layer.cornerRadius = 20
        corneredView.layer.masksToBounds = false
        corneredView.layer.shadowOpacity = 0.2
        corneredView.layer.shadowColor = UIColor.black.cgColor
        corneredView.layer.shadowOffset = CGSize.zero
        corneredView.layer.shadowRadius = 5
    }

    func fill(_ question: Item?) {
        questionLabel.text = question?.title
        authorLabel.text = question?.owner?.displayName
        numberOfAnswerLabel.text = String(format: "%li", Int(question?.answerCount ?? 0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm d-MM-yyyy"
        if let aFormat = question?.smartDateFormat,
           let lastDateValue = question?.lastActivityDate,
           let timeInterval = TimeInterval( exactly: lastDateValue) {
            let aDate = Date.init(timeIntervalSince1970: timeInterval)
            dateModificationLabel.text = "\(dateFormatter.string(from: aDate)) \(aFormat)"
        }
    }

}
