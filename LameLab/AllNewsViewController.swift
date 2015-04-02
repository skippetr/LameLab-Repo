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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.hidesBarsOnSwipe = true
        
        loadData()
                
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
                }
            }
        }
        
        tableView.reloadData()
        
        /*
        let oneNews = JSON?.valueForKey("10") as NSDictionary
        let titleOfNews = oneNews.valueForKey("title") as String
        println(titleOfNews)
        println(JSON)
        */
    }
    
    func loadData() {
        Alamofire.request(.GET, "http://www.lamelab.com/api.php", parameters: ["foo": "bar"])
            .responseJSON { (_, _, JSON, error) in
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
        return newsList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = newsList[indexPath.row]
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
                    vc.id = self.tableView.indexPathForSelectedRow()?.row
                }
            }
        }
    }
    
    // MARK: - etc.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

