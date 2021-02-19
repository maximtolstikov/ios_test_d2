//
//  ContainerViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // FIXME: - Excess outlets!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var leadingTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerNavigationItem: UINavigationItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "objective-c"
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestedTagNotification(_:)), name: NSNotification.Name("RequestedTagNotification"), object: nil)
    }

    @objc func requestedTagNotification(_ notification: NSNotification) {
        if let requestedTag = notification.object as? String {
            title = requestedTag            
        }
    }
    
    @IBAction func menu(_ sender: Any) {
        if leadingTableViewLayoutConstraint.constant == 0 {
            leadingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width / 2
            trailingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width * -0.5
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            leadingTableViewLayoutConstraint.constant = 0
            trailingTableViewLayoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }    
}
