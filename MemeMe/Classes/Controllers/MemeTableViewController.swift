//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Felipe Lloret on 26/05/15.
//  Copyright (c) 2015 Felipe Lloret. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var editorButton: UIBarButtonItem!
    @IBOutlet weak var memesTableView: UITableView!
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.memesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = "\(meme.topString) \(meme.bottomString)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailview") as! MemeDetailViewController
//        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func gotoMemeEditor(sender: AnyObject) {
        let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
}
