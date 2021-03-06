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
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        memesTableView.reloadData()
        
        // Adds Edit/Done button
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Disable edit button if no memes available
        navigationItem.leftBarButtonItem?.enabled = memes.count > 0
        
        // Show tabBar
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.memeTextLabel.text = "\(meme.topString) \(meme.bottomString)"
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Remove Meme and update Meme Object
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            memes.removeAtIndex(indexPath.row)
            applicationDelegate.memes = memes
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        navigationItem.leftBarButtonItem?.enabled = memes.count > 0
        setEditing(memes.count > 0, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailViewController
        detailController.memes = memes
        detailController.index = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        memesTableView.setEditing(editing, animated: animated)
    }
    
    @IBAction func gotoMemeEditor(sender: AnyObject) {
        let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
}
