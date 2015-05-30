//
//  ViewController.swift
//  MemeMe
//
//  Created by Felipe Lloret on 26/05/15.
//  Copyright (c) 2015 Felipe Lloret. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    var oldMemedImage: UIImage!
    var oldTopText: String!
    var oldBottomText: String!
    
    var selectedTextField: UITextField?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set text fields
        self.initMemeTextFields()
        
        // Set texfields default text
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Set textfields center-aligned
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        // Set textfields delegate
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        shareButton.enabled = false
        
        // Disables cameraButton if device doesn't support picking media from camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Check if editing old Meme
        if oldMemedImage != nil {
            self.editOldMeme()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func editOldMeme() {
        shareButton.enabled = true
        
        imagePickerView.image = oldMemedImage
        topTextField.text = oldTopText
        bottomTextField.text = oldBottomText
    }
    
    // MARK: Text field methods
    func initMemeTextFields() {
        // Set font style and color
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedTextField = textField
        
        // Clear default text only
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        selectedTextField = nil
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Meme Editor Actions
    // Share Meme image
    @IBAction func shareMemeImage(sender: AnyObject) {
        // Generate a Memed image
        self.generateMemedImage()
        
        // Pass the image and show the ActivityViewController
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [self.generateMemedImage()], applicationActivities: nil)
        
        // After ActivityViewController has done its work we save the meme
        activityViewController.completionWithItemsHandler = { (type: String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) in
            if completed {
                self.save()
            } else {
                println(error)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // Close Meme Editor
    @IBAction func closeMemeEditor(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Pick and image from Photo album
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Pick an image from camera
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Picker Controller Methods
    // User selects an image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = selectedImage
            
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User cancels image selection
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Meme Model Methods
    func save() {
        // Create the meme
        var meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        self.hideToolBars()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.showToolBars()
        
        return memedImage
    }
    
    func hideToolBars() {
        topToolBar.hidden = true
        bottomToolBar.hidden = true
    }
    
    func showToolBars() {
        topToolBar.hidden = false
        bottomToolBar.hidden = false
    }
    
    // MARK: Notification Methods
    func keyboardWillShow(notification: NSNotification) {
        // Accomodate keyboard only when bottom textfield is selected
        if let textField = self.selectedTextField {
            if textField == self.bottomTextField {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}
