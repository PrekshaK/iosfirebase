//
//  addcontroller.swift
//  firewater
//
//  Created by Preksha Koirala on 4/10/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var is_private: Bool!

class addcontroller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mImageView: UIImageView!
    var maincontr: ViewController!
    var firestuff: firebaseStuff!
    
    var currentitem: Firebase!
    
    
    
    
    @IBOutlet weak var private_button: UIButton!
    
    let imagePicker = UIImagePickerController();
    
    static var BASE_URL = "https://koirala.firebaseio.com"
    let ItemsRef = Firebase(url: BASE_URL)
    
    var itemlist = [items]();
    
    
    override func viewDidLoad() {
        
        is_private = false;
        print (teststring)
        print (authdataid)
        
        
        
        imagePicker.delegate = self;
        super.viewDidLoad()
    }

    @IBAction func is_Private(sender: AnyObject) {
        
        is_private = true;
        private_button.backgroundColor = UIColor.yellowColor();
        
        
    }
    
    @IBOutlet weak var mtextfield: UITextField!
    
    @IBAction func mchoose(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
        
        
    }
    
    
    @IBAction func mupload(sender: AnyObject) {

        private_button.backgroundColor = UIColor.whiteColor();
        var data: NSData = NSData()
        if let image = mImageView.image{
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let oneitem: NSDictionary = ["text1": self.mtextfield.text!, "image1": base64String];
        let str = self.mtextfield.text!
        
        firebaseStuff().upload(oneitem, str: str);
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print ("hi")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mImageView.contentMode = .ScaleAspectFit
            print (pickedImage);
            mImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    
    
}
