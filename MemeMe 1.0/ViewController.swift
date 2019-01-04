//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Deena Tenzer on 1/5/18.
//  Copyright © 2018 Deena Tenzer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let textFieldDelegate = TextFieldDelegate()
    var currentTextField: UITextField!
    
    
    let imagePicker = UIImagePickerController()
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(textField: topTextField, withText: "TOP")
        configure(textField: bottomTextField, withText: "BOTTOM")
        shareButton.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func configure(textField: UITextField, withText text: String){
        textField.delegate = self.textFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.navigationController?.isNavigationBarHidden = false
        
    }
    

    @IBAction func pressedCancel(_ sender: Any) {
        self.viewDidLoad()
        imagePickerView.image = nil
        shareButton.isEnabled = false
        self.dismiss(animated:true, completion: nil)
    }

    @IBAction func pickAnImage(_ sender: AnyObject) {
        
        presentImagePickerWith(sourcetype: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        presentImagePickerWith(sourcetype: .camera)
    }
    
    func presentImagePickerWith(sourcetype: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourcetype
        imagePicker.delegate = self
        shareButton.isEnabled = true
        imagePickerView.contentMode = .scaleAspectFit
        present(imagePicker, animated: true, completion: nil)
    }
    

    //Tells the delegate that the user picked a still image or movie.
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = selectedImage
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
            
        }
        
        _picker.dismiss(animated: true, completion: nil)
    }
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ _picker: UIImagePickerController) {
        _picker.dismiss(animated: true, completion: nil)
    }
    
    
    //Keyboard code:
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    
    @IBAction func bottomButtonEdited() {
        self.currentTextField = bottomTextField
    }
    
    @IBAction func topButtonEdited() {
        self.currentTextField = topTextField
    }

    
    func keyboardWillShow(_ notification:Notification) {
        if(currentTextField == bottomTextField){
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification){
        self.view.frame.origin.y = 0

    }

    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
          // TODO: Hide toolbar and navbar
        configureBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        // TODO: Show toolbar and navbar
        configureBars(hidden: false)
        
        return memedImage
    }
    
    func configureBars(hidden: Bool){
        navBar.isHidden = hidden
        toolBar.isHidden = hidden
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = self.generateMemedImage()
        
        let actViewController = UIActivityViewController(activityItems: ["Check out my Meme!", memeImage], applicationActivities: nil)
        
        actViewController.completionWithItemsHandler = {
            (s, ok, items, err) in
            self.save(memedImage:memeImage)
        }
        self.present(actViewController, animated: true, completion: nil)

    }
    
    
    
    func save(memedImage:UIImage) {
        // update the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // add it to the memes array in the AppDelegate
        (UIApplication.shared.delegate as!AppDelegate).memes.append(meme)
    }

    
    
}

