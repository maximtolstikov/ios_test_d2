//
//  DetailViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let kQuestionCellIdentifier = "CellForQuestion"
    private let kAnswerCellIdentifier = "CellForAnswer"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    // FIXME: - Force unwrap!
    let refreshControl = UIRefreshControl()
    let activityIndicatorView = UIActivityIndicatorView()
    var answers = [AnswerItem()]
    var currentQuestion: Item?
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: kAnswerCellIdentifier)
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: kQuestionCellIdentifier)
        addRefreshControlOnTableView()
        settingDynamicHeightForCell()
        addActivityIndicator()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if answers.count == 0 {
            activityIndicatorView.startAnimating()
        }
        return answers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kQuestionCellIdentifier, for: indexPath) as? QuestionTableViewCell
            cell?.fill(currentQuestion)
            titleNavigationItem.title = "\(String(describing: currentQuestion?.title ?? ""))"
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kAnswerCellIdentifier, for: indexPath) as? AnswerTableViewCell
            var answer: AnswerItem?
            answer = answers[indexPath.row - 1]
            cell?.fill(answer)
            return cell ?? UITableViewCell()
        }
    }
    
    @objc func reloadData() {
        tableView.reloadData()
        let title = "Last update: \(formatter.string(from: Date()))"
        let attrsDictionary = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.endRefreshing()
    }
    
    // MARK: - Public
    func loadAnswers() {
        if let unwrappedId = currentQuestion?.questionId {
            // FIXME: - Memory leak!
            FabricRequest.request(withQuestionID: unwrappedId) { data in
                self.reload(inTableView: data)
            }
        }
    }

    // MARK: - Private
    func addActivityIndicator() {
        activityIndicatorView.style = .gray
        let bounds: CGRect = UIScreen.main.bounds
        activityIndicatorView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    func addRefreshControlOnTableView() {
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        refreshControl.backgroundColor = UIColor.white
        tableView.addSubview(refreshControl)
    }
    
    func settingDynamicHeightForCell() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func reload(inTableView jsonData: Data?) {
        answers = [AnswerItem]()
        if let data = jsonData,
           let answerModel = try? JSONDecoder().decode(Answer.self, from: data),
           let unwrappedItems = answerModel.items {
            answers = unwrappedItems
        }
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        })
    }

}
