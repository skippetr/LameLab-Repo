//
//  ShowAllNewsTableViewController.swift
//  LameLab
//
//  Created by user on 05.04.15.
//  Copyright (c) 2015 Goxit Design. All rights reserved.
//

import UIKit
import Alamofire
import Spring

class ShowAllNewsTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBAction func refreshNews(sender: UIRefreshControl) {
        sender.attributedTitle = NSAttributedString(string: "Идет обновление...")
        newsList.removeAll()
        idList.removeAll()
        imgList.removeAll()
        tagsList.removeAll()
        beginWith = 0
        loadData()
        sender.endRefreshing()
    }
    
    var newsList = [String]()
    var idList = [String]()
    var imgList = [String]()
    var tagsList = [NSArray]()
    var backView: UIView?
    var beginWith = 0
    
    var loadMoreStatus = false // SCROLL
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let background = UIView(frame: CGRectMake(self.view.bounds.midX - 50, self.view.bounds.midY - 100, 100, 100)) as UIView
        background.layer.cornerRadius = 10
        background.alpha = 0.7
        background.backgroundColor = UIColor.blackColor()
        tableView.addSubview(background)
        tableView.bringSubviewToFront(background)
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activity.center = CGPointMake(50, 50)
        activity.startAnimating()
        background.addSubview(activity)
        backView = background
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

//        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        dispatch_async(dispatch_get_global_queue(priority, 0)) { () -> Void in
//            self.loadData()
//        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // SCROLL
//        refreshControl = UIRefreshControl()
//        refreshControl?.attributedTitle = NSAttributedString(string: "Идет обновление...")
//        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        tableView.addSubview(refreshControl!)
        self.tableView.tableFooterView?.hidden = true
        
        //self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    // SCROLL
//    func refresh(sender: AnyObject) {
//        println("refreshing")
//    }
    override func scrollViewDidScroll(scrollView: (UIScrollView)) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            loadMore()
        }
    }
    func loadMore() {
        if ( !loadMoreStatus ) {
            self.loadMoreStatus = true
            let footer = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 30))
            let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            activity.center = CGPointMake(self.view.bounds.midX, 15)
            activity.startAnimating()
            footer.addSubview(activity)
            self.tableView.tableFooterView = footer
            self.tableView.tableFooterView?.hidden = false
            loadMoreBegin("Load more",
                loadMoreEnd: {(x:Int) -> () in
                    //self.tableView.reloadData()
                    self.loadMoreStatus = false
                    self.tableView.tableFooterView?.hidden = true
                    activity.stopAnimating()
            })
        }
    }
    func loadMoreBegin(newtext: String, loadMoreEnd: (Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //println("loadmore")
            self.loadData()
            sleep(4)
            
            dispatch_async(dispatch_get_main_queue()) {
                loadMoreEnd(0)
            }
        }
    }
    // SCROLL END
    
    func jsonParse(JSON: AnyObject?) {
        if let array = JSON as? NSArray {
            for i in 0..<array.count {
                if let element = array[i] as? NSDictionary {
                    self.newsList.append(element.valueForKey("title") as String)
                    self.idList.append(element.valueForKey("id") as String)
                    self.imgList.append(element.valueForKey("imageURL") as String)
                    self.tagsList.append(element.valueForKey("terms") as NSArray)
                }
            }
        }
        tableView.reloadData()
        beginWith += 10
        //println(idList.count)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
//        backView?.animation = "zoomOut"
//        backView?.duration = 1.7
//        backView?.animate()
        
        backView?.removeFromSuperview()
    }
    
    func loadData() {
        
        if category == nil { category = "all" }
        
        Alamofire.request(.GET, "http://www.lamelab.com/api.php", parameters: ["show": category!, "beginWith": beginWith])
            .responseJSON { (_, _, JSON, error) in
                if error == nil {
                    self.jsonParse(JSON)
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: "При загрузке возникла ошибка. Возможно отсутствует подключение к сети.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Перезагрузить", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.loadData()
                    }))
                    alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                        
                    }))
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as ShowAllNewsTableViewCell
        
        cell.tag = indexPath.row
        
        if newsList.count > 0 {
            cell.newsTitle.text = newsList[indexPath.row]
            
            var labelTags = tagsList[indexPath.row][0] as String
            for i in 1..<tagsList[indexPath.row].count {
                labelTags = labelTags + ", " + (tagsList[indexPath.row][i] as String)
            }
            cell.newsTags.text = labelTags
            
            ImageLoader.sharedLoader.imageForUrl(imgList[indexPath.row], completionHandler:{(image: UIImage?, url: String) in
                if (cell.tag == indexPath.row) {
                    if image != nil {
                        cell.newsImage.image = image
                    } else {
                        cell.newsImage.image = UIImage(named: "placeholder")
                    }
                }
            })
        }
        
        
//        var imgURL = imgList[indexPath.row].stringByReplacingOccurrencesOfString(".jpeg", withString: "-150x150.jpeg", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        imgURL = imgURL.stringByReplacingOccurrencesOfString(".jpg", withString: "-150x150.jpg", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        imgURL = imgURL.stringByReplacingOccurrencesOfString(".gif", withString: "-150x150.gif", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
//        let url = NSURL(string: imgList[indexPath.row])
        
//        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
//            let data = NSData(contentsOfURL: url!)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                if data != nil {
//                    cell.newsImage.image = UIImage(data: data!)
//                } else {
//                    cell.newsImage.image = UIImage(named: "placeholder.imageset")
//                }
//            })
//        })
        

        
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            println("Delete")
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let myFavActionRow = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "В избранное") { (rowAction, indexPath) -> Void in
        }
        myFavActionRow.backgroundColor = UIColor(hex: "0498EC")
        //myActionRow.backgroundColor = UIColor(patternImage: UIImage(named:"fav")!)
        
        let myShareActionRow = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Поделиться") { (rowAction, indexPath) -> Void in
        }
        myShareActionRow.backgroundColor = UIColor(hex: "cccccc")
    
        return [myFavActionRow, myShareActionRow]
    }

    // MARK: - Segue
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toTheArticle", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let article = segue.identifier {
            if article == "toTheArticle" {
                if let vc = segue.destinationViewController as? SingleArticleController {
                    vc.title = "Статья"
                    vc.id = idList[self.tableView.indexPathForSelectedRow()!.row].toInt()!
                    //vc.tags = "test tag"
                }
            }
        }
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }

}
