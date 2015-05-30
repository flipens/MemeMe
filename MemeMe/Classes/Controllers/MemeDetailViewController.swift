//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Felipe Lloret on 26/05/15.
//  Copyright (c) 2015 Felipe Lloret. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var memes: [Meme]!
    var index: Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memedImageView.image = memes[index].memedImage
    }
    
    @IBAction func gotoMemeEditor(sender: AnyObject) {
        let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        memeEditorController.oldMemedImage = memes[index].image
        memeEditorController.oldTopText = memes[index].topString
        memeEditorController.oldBottomText = memes[index].bottomString
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
    @IBAction func deteleMeme(sender: AnyObject) {
        let index = self.index
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes.removeAtIndex(index)
        applicationDelegate.memes = memes
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
