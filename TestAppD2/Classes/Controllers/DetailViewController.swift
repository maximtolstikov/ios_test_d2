//
//  DetailViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let kQuestionCellIdentifier = "CellForQuestion"
    private let kAnswerCellIdentifier = "CellForAnswer"
    
    var currentQuestion: Item?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleNavigationItem: UINavigationItem!
    private let refreshControl = UIRefreshControl()
    private let activityIndicatorView = UIActivityIndicatorView()
    private var answers = [AnswerItem()]
    
    private var refreshControlFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter
    }()
    private var tableViewCellFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm d-MM-yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addRefreshControlOnTableView()
        settingDynamicHeightForCell()
        addActivityIndicator()
    }
    
    // MARK: - TableView
    private func configureTableView() {
        tableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: kAnswerCellIdentifier)
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: kQuestionCellIdentifier)
    }
    
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
            cell?.fill(answer, dateFormatter: tableViewCellFormatter)
            return cell ?? UITableViewCell()
        }
    }
    
    @objc func reloadData() {
        tableView.reloadData()
        let title = "Last update: \(refreshControlFormatter.string(from: Date()))"
        let attrsDictionary = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.endRefreshing()
    }
    
    // MARK: - Public
    func loadAnswers() {
        if let unwrappedId = currentQuestion?.questionId {
            FabricRequest.request(withQuestionID: unwrappedId) { data in
                self.reload(inTableView: data)
            }
        }
    }

    // MARK: - Private
    private func addActivityIndicator() {
        activityIndicatorView.style = .gray
        let bounds: CGRect = UIScreen.main.bounds
        activityIndicatorView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    private func addRefreshControlOnTableView() {
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        refreshControl.backgroundColor = UIColor.white
        tableView.addSubview(refreshControl)
    }
    
    private func settingDynamicHeightForCell() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func reload(inTableView jsonData: Data?) {
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
