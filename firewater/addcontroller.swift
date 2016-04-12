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

class addcontroller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mImageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController();
    
    static var BASE_URL = "https://koirala.firebaseio.com"
    let ItemsRef = Firebase(url: BASE_URL)
    
    var itemlist = [items]();
    
    
    override func viewDidLoad() {
        imagePicker.delegate = self;
        super.viewDidLoad()
    }

    
    @IBOutlet weak var mtextfield: UITextField!
    
    @IBAction func mchoose(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func mupload(sender: AnyObject) {
        
        
        var data: NSData = NSData()
        
        
        if let image = mImageView.image{
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        var newitem = items()
        newitem.image1 = base64String;
        newitem.textmsg = self.mtextfield.text;
        
        itemlist.append(newitem)
        
        
        
        let oneitem: NSDictionary = ["text1": newitem.textmsg!, "image1": newitem.image1!];
        let str = newitem.textmsg;
        
        let currentitem = ItemsRef.ref.childByAppendingPath(str)
        
        currentitem.setValue(oneitem)
        
        print ("successfully saved data");
        
        
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
