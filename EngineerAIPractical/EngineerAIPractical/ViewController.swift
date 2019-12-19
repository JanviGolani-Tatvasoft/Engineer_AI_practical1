//
//  ViewController.swift
//  EngineerAIPractical
//
//  Created by PCQ111 on 19/12/19.
//  Copyright © 2019 PCQ111. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll

class ViewController: UIViewController {

    //MARK : Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK : Variables
    private var pageNumber  = 0
    private var nbPages     = 0
    
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handlePullToRefresh), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        return refreshControl
    }()

    //MARK : Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    private func prepareUI(){
        self.title = "No post selected."
        self.tableView.addSubview(refreshControl)
        self.tableView.tableFooterView = UIView()
        
        self.tableView.addInfiniteScroll { (table) in
            table.finishInfiniteScroll()
        }
    }
    
    @objc private func handlePullToRefresh(){
        
    }
}

