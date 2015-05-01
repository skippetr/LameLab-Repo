//
//  ViewController.swift
//  LameLab
//
//  Created by user on 22.02.15.
//  Copyright (c) 2015 Goxit Design. All rights reserved.
//

import UIKit
import Alamofire

class AllNewsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Property list
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var newsList = [String]()
    var idList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        let activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activity.backgroundColor = UIColor.blackColor()
        activity.alpha = 0.7
        activity.layer.cornerRadius = 10
        activity.frame = CGRectMake(0, 0, 100, 100)
        activity.center = CGPointMake(self.view.bounds.midX, self.view.bounds.midY-50)
        activity.layer.zPosition = 2
        self.tableView.addSubview(activity)
        //tableView.tableFooterView = activity
        //activity.startAnimating()
        
//        var downloadQueue = dispatch_queue_create("downloader", nil)
//        dispatch_async(downloadQueue, {
//            self.loadData()
//            dispatch_async(dispatch_get_main_queue(), {
//                activity.removeFromSuperview()
//                //self.tableView.tableFooterView = nil
//            })
//        })
        
        //navigationController!.hidesBarsOnSwipe = true
        
        //loadData()
                
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    // MARK: - Network activity
    
    func jsonParse(JSON: AnyObject?) {
        
        if let array = JSON as? NSArray {
            for i in 0..<array.count {
                if let element = array[i] as? NSDictionary {
                    self.newsList.append(element.valueForKey("title") as String)
                    self.idList.append(element.valueForKey("id") as String)
                }
            }
        }
        
        tableView.reloadData()
//        tableView.setNeedsLayout()
//        tableView.layoutIfNeeded()
//        tableView.estimatedRowHeight = 200 //tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.reloadData()
    
    }
    
    func loadData() {
        Alamofire.request(.GET, "http://www.lamelab.com/api.php", parameters: ["foo": "bar"])
            .responseJSON { (_, _, JSON, error) in
//                println(JSON)
//                println(error)
                self.jsonParse(JSON)
        }
        
        //            .response { (request, response, _, error) in
        //                println("\(request) \n\n\n")
        //                println("\(response) \n\n\n")
        //                //println("\(data) \n\n\n")
        //                println("\(error) \n\n\n")
        //        }
        
    }

    //MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //newsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as AllNewsTableViewCell
        cell.newsTitle.text = newsList[indexPath.row]
        //cell.newsImage.image = UIImage(named: "placeholder")
        
//        cell.setNeedsUpdateConstraints()
//        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toTheArticle", sender: self)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let article = segue.identifier {
            if article == "toTheArticle" {
                if let vc = segue.destinationViewController as? SingleArticleController {
                    vc.title = "Статья"
                    //println(newsList[self.tableView.indexPathForSelectedRow()!.row])
                    vc.id = idList[self.tableView.indexPathForSelectedRow()!.row].toInt()!
                }
            }
        }
    }
    
    // MARK: - etc.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

