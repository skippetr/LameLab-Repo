//
//  ViewController.swift
//  LameLab
//
//  Created by user on 22.02.15.
//  Copyright (c) 2015 Goxit Design. All rights reserved.
//

import UIKit
import Alamofire

var count:Int?

class AllNewsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.hidesBarsOnSwipe = true
        
        println(loadData())
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func loadData() -> AnyObject? {
        var jsonResult: AnyObject?
        
        Alamofire.request(.GET, "http://www.lamelab.com/api.php", parameters: ["foo": "bar"])
            .responseJSON { (_, _, JSON, _) in
                //println(JSON)
                jsonResult = JSON
        }
        
        return jsonResult
        
        //            .response { (request, response, _, error) in
        //                println("\(request) \n\n\n")
        //                println("\(response) \n\n\n")
        //                //println("\(data) \n\n\n")
        //                println("\(error) \n\n\n")
        //        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "test"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        count = indexPath.row
        performSegueWithIdentifier("toTheArticle", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let article = segue.identifier {
            if article == "toTheArticle" {
                if let vc = segue.destinationViewController as? SingleArticleController {
                    vc.title = "Статья"
                }
            }
        }
    }
    
    

}

