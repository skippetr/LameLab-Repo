//
//  SingleArticleController.swift
//  LameLab
//
//  Created by user on 22.02.15.
//  Copyright (c) 2015 Goxit Design. All rights reserved.
//

import UIKit

class SingleArticleController: UIViewController {

    
    @IBOutlet weak var test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test.text = String(count!)
        
        let myView = UIView(frame: CGRectMake(100, 200, 200, 200))
        myView.layer.cornerRadius = 30.0
        myView.backgroundColor = UIColor.blueColor()
        myView.alpha = 0
        
        UIView.animateWithDuration(2.0, animations: {
            self.view.addSubview(myView)
            myView.alpha = 1
        })
        
        navigationController?.hidesBarsOnSwipe = true
        
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
