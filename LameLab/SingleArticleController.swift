//
//  SingleArticleController.swift
//  LameLab
//
//  Created by user on 22.02.15.
//  Copyright (c) 2015 Goxit Design. All rights reserved.
//

import UIKit
import Alamofire
import Spring

class SingleArticleController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var contentWebView: UIWebView!
    var id: Int?
    //var tags: String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spinnerBackground: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //println(id)
        
        contentWebView.delegate = self
        
        /*
        let spinnerBackground = UIView(frame: CGRectMake(0, 0, 100, 100))
        spinnerBackground.center = CGPointMake(self.view.bounds.midX, self.view.bounds.midY)
        spinnerBackground.layer.cornerRadius = 10
        spinnerBackground.backgroundColor = UIColor.blackColor()
        spinnerBackground.alpha = 1 //0.5
        self.view.addSubview(spinnerBackground)
        */
        
        loadData()
        
        /*
        let myView = UIView(frame: CGRectMake(100, 200, 200, 200))
        myView.layer.cornerRadius = 30.0
        myView.backgroundColor = UIColor.blueColor()
        myView.alpha = 0
        
        UIView.animateWithDuration(2.0, animations: {
            self.view.addSubview(myView)
            myView.alpha = 1
        })
        */
        
        navigationController?.hidesBarsOnSwipe = false
        
        //let shareButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "showActionSheet")
        let shareImage = UIImage(named: "share")
        let shareButtonItem = UIBarButtonItem(image: shareImage, style: UIBarButtonItemStyle.Plain, target: self, action: "showActionSheet")
        navigationItem.rightBarButtonItem  = shareButtonItem
                
        /*
        navigationController!.setNavigationBarHidden(false, animated:true)
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("YOUR TITLE", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        */
        
        //navigationItem.title = "The title"
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Network activity
    
    func jsonParse(JSON: AnyObject?) {
        
        var script1: String!
        var script2: String!
        
        let pathForJS = NSBundle.mainBundle().pathForResource("jquery.hyphen.ru.min", ofType: "js")
        if let js = NSString(contentsOfFile: pathForJS!, encoding: NSUTF8StringEncoding, error: nil) as? String {
            script1 = js
        }
        
        let pathForjQuery = NSBundle.mainBundle().pathForResource("jquery-1.11.2.min", ofType: "js")
        if let jQuery = NSString(contentsOfFile: pathForjQuery!, encoding: NSUTF8StringEncoding, error: nil) as? String {
            script2 = jQuery
        }
        
        if let array = JSON as? NSArray {
            if let element = array[0] as? NSDictionary {
                let image = element.valueForKey("imageURL") as String
                let title = element.valueForKey("title") as String                
                
                let content = element.valueForKey("content") as String
                let pTags = content.stringByReplacingOccurrencesOfString("\r\n\r\n", withString: "</p><p>", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let brTags = pTags.stringByReplacingOccurrencesOfString("\r\n", withString: "<br />", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let html = "<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>a { text-decoration: none; color: black; } img { display: block; height: auto; max-width: 100%;} iframe { width: 100% !important; height: auto !important; margin-left: -20px; } h2 { font-family: inherit; font-weight: 400; line-height: 1.1; color: #444444; } p { font-family:Helvetica; font-size:18px; color: #333333; text-indent: 20px; text-align: justify; -webkit-hyphens: auto; -moz-hyphens: auto; -ms-hyphens: auto; hyphens: auto; } blockquote { padding: 11.5px 23px; margin: 0 0 23px; font-size: 16.25px; border-left: 5px solid #eeeeee;  font-style: italic; }</style><script>\(script2)</script><script>\(script1)</script><script> $(function(){ $('p').hyphenate(); });</script></head><body style=\"\"><h2>\(title)</h2><img src=\"\(image)\" /><p>\(brTags)</p></body></html>"
                self.contentWebView.loadHTMLString(html, baseURL: nil)
//                activityIndicator.stopAnimating()
//                spinnerBackground.removeFromSuperview()
            }
        }
    }
    
    func loadData() {
        activityIndicator.startAnimating()
        
        Alamofire.request(.GET, "http://www.lamelab.com/api.php", parameters: ["id": self.id!])
            .responseJSON { (request, _, JSON, _) in
            self.jsonParse(JSON)
        }
        
        //            .response { (request, response, _, error) in
        //                println("\(request) \n\n\n")
        //                println("\(response) \n\n\n")
        //                //println("\(data) \n\n\n")
        //                println("\(error) \n\n\n")
        //        }

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        spinnerBackground.animation = "fadeOut"
        spinnerBackground.duration = 0.7
        spinnerBackground.animate()
        
        /*
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.spinnerBackground.frame = CGRectMake(self.view.bounds.midX-60, self.view.bounds.midY-60, 120, 120)
            self.spinnerBackground.alpha = 0.0
            }) { (finish) -> Void in
            self.spinnerBackground.hidden = true
            self.spinnerBackground.removeFromSuperview()
        }
        */
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Копировать ссылку", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            UIPasteboard.generalPasteboard().string = "http://www.lamelab.com/?p=\(self.id!)"
            let background = UIView(frame: CGRectMake(110, 230, 100, 100))
            background.layer.cornerRadius = 10
            background.alpha = 0.7
            background.backgroundColor = UIColor.blackColor()
            self.view.addSubview(background)
            let image = UIImageView(frame: CGRectMake(25, 30, 50, 40))
            image.image = UIImage(named: "ok")
            background.addSubview(image)
            
            UIView.animateWithDuration(0.7, delay: 0.5, options: nil, animations: { () -> Void in
                background.alpha = 0
            }, completion: { (finish) -> Void in
                background.removeFromSuperview()
            })
        }))
        alert.addAction(UIAlertAction(title: "Вконтакте", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func popToRoot(sender:UIBarButtonItem) {
        //self.navigationController!.popToRootViewControllerAnimated(true)
        self.navigationController!.popViewControllerAnimated(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
