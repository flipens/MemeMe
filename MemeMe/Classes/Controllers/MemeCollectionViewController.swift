//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Felipe Lloret on 26/05/15.
//  Copyright (c) 2015 Felipe Lloret. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var editorButton: UIBarButtonItem!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        memeCollectionView.reloadData()
        
        // Adds Edit/Done button
        navigationItem.leftBarButtonItem = editButtonItem()

        // Disable edit button if no memes available
        navigationItem.leftBarButtonItem?.enabled = memes.count > 0
        
        // Show tabBar
        self.tabBarController?.tabBar.hidden = false
    }
    
    //MARK: CollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the image and delete button
        cell.memedImageView.image = meme.memedImage
        cell.deleteButton?.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton?.hidden = !editing
        cell.deleteButton?.addTarget(self, action: "deleteCell:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailViewController
        detailController.memes = memes
        detailController.index = indexPath.row        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        memeCollectionView.reloadData()
    }
    
    func deleteCell(sender: UIButton) {
        // Remove Meme and update Meme Object
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes.removeAtIndex(i)
        applicationDelegate.memes = memes
        
        // Disable edit button if no memes available
        navigationItem.leftBarButtonItem?.enabled = memes.count > 0
        setEditing(memes.count > 0, animated: true)
    }
    
    @IBAction func gotoMemeEditor(sender: AnyObject) {
        let memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
}
            