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

final class ViewController: UIViewController {
    //MARK : Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK : Variables
    private var pageNumber            = 0
    private var nbPages               = 0
    private var hitsList: [HitsList]  = []
    
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
        getUserData(with: self.pageNumber)
    }
    
    //MARK : prepareUI
    private func prepareUI() {
        self.title = Message.message.selectedPost + "0"
        self.tableView.addSubview(refreshControl)
        self.tableView.tableFooterView = UIView()
        self.tableView.addInfiniteScroll { (table) in
            table.finishInfiniteScroll()
        }
    }
    
    //MARK : API Calling
    private func getUserData(with pageNumber : Int = 0) {
        if Connectivity.isConnectedToInternet {
            if self.pageNumber == 0 {
                SVProgressHUD.show()
            }
            RequestManager.requestWithGET(with: API.getHits(page: pageNumber)) { (status, responseData, message) in
                SVProgressHUD.dismiss()
                do {
                    let mainResponse  = try JSONDecoder().decode(HitsResponse.self, from: responseData)
                    if let hitsData = mainResponse.hits {
                        self.hitsList.append(contentsOf: hitsData)
                        self.nbPages = mainResponse.nbPages ?? 0
                        self.tableView.reloadData()
                        if self.pageNumber == self.nbPages {
                            self.tableView.removeInfiniteScroll()
                        }
                    }
                }
                catch {
                    debugPrint("error getting Hits List : \(error.localizedDescription)")
                }
            }
        } else {
            self.showAlert()
        }
    }
    
    //MARK : Display alert
    private func showAlert() {
        let alert = UIAlertController(title: Message.message.alert, message: Message.message.internetNotAvailable, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Message.message.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK : HGandle Pull To Refresh method
    @objc private func handlePullToRefresh() {
        self.pageNumber = 0
        self.hitsList.removeAll()
        self.tableView.reloadData()
        self.getUserData(with: self.pageNumber)
        refreshControl.endRefreshing()
        displayCount()
    }
    
    //MARK : Display count on Navigation bar
    private func displayCount() {
        let selectedPost =  self.hitsList.filter {$0.isActive == true}
        if selectedPost.count <= 1 {
            self.title = Message.message.selectedPost + "\(selectedPost.count)"
        }else {
            self.title =  Message.message.selectedPosts + "\(selectedPost.count)"
        }
    }
    
    //MARK : Switch change action
    @objc private func switchChanged(sender : UISwitch) {
        if let isActive = self.hitsList[sender.tag].isActive {
            self.hitsList[sender.tag].isActive! = !isActive
        }
        else {
            self.hitsList[sender.tag].isActive = true
        }
        self.displayCount()
        let indexPath = IndexPath(row : sender.tag , section : 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
}

//MARK : UITableViewDelegate, UITableViewDataSource extension
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hitsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HitsCell = self.tableView.dequeueReusableCell(withIdentifier: "HitsCell", for: indexPath) as! HitsCell
        cell.postHit = self.hitsList[indexPath.row]
        cell.displaySwitch.tag = indexPath.row
        cell.displaySwitch.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == self.hitsList.count - 1 && self.pageNumber != self.nbPages) {
            self.pageNumber = self.pageNumber + 1
            self.getUserData(with: self.pageNumber)
        }
    }
    
}
