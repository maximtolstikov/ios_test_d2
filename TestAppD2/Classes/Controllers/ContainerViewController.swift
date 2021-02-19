//
//  ContainerViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {

    @IBOutlet private weak var leadingTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerNavigationItem: UINavigationItem!
    
    private var embeddedMasterViewController: MasterViewController?
    private var screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer()
    private var swipeRecognizer = UISwipeGestureRecognizer()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "objective-c"
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.requestedTagNotification(_:)),
            name: NSNotification.Name("RequestedTagNotification"),
            object: nil
        )
        configureGestureRecognizers()
    }

    @objc private func requestedTagNotification(_ notification: NSNotification) {
        if let requestedTag = notification.object as? String {
            title = requestedTag            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let viewController = segue.destination as? MasterViewController,
               segue.identifier == "MasterViewControllerEmbedSegue" {
                self.embeddedMasterViewController = viewController
            }
        }
    
    private func configureGestureRecognizers() {
        screenEdgePanRecognizer.addTarget(self, action: #selector(menu(_:)))
        screenEdgePanRecognizer.edges = .left
        view.addGestureRecognizer(screenEdgePanRecognizer)
        
        swipeRecognizer.addTarget(self, action: #selector(menu(_:)))
        swipeRecognizer.direction = .left
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @IBAction private func menu(_ sender: Any) {
        if leadingTableViewLayoutConstraint.constant == 0 {
            screenEdgePanRecognizer.isEnabled = false
            leadingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width / 2
            trailingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width * -0.5
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
            swipeRecognizer.isEnabled = true
            embeddedMasterViewController?.tableView.allowsSelection = false
        } else {
            leadingTableViewLayoutConstraint.constant = 0
            trailingTableViewLayoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
            screenEdgePanRecognizer.isEnabled = true
            swipeRecognizer.isEnabled = false
            embeddedMasterViewController?.tableView.allowsSelection = true
        }
    }
    
}
