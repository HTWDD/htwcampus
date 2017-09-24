//
//  TableViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23.05.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class TableViewController: ViewController {

    let tableView = UITableView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }

    func initialSetup() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = .white
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.tableView)

        self.tableView.delegate = self
    }

}

extension TableViewController: UITableViewDelegate {}