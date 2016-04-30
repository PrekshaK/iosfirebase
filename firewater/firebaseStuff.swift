//
//  firebasestuff.swift
//  firewater
//
//  Created by Preksha Koirala on 4/29/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class firebaseStuff {
    
    var currentitem: Firebase!
    var authData: FAuthData!
    var maincontr: ViewController!
    var addcontr: addcontroller!
    var loggedIn: Bool!

    static var BASE_URL = "https://koirala.firebaseio.com"
    let ItemsRef = Firebase(url: BASE_URL)
    
    
    static var sharedInstance = firebaseStuff();
    
    
    func  doLogin(email: String, pass: String ){
        print ("in login")
        print (pass)
        ItemsRef.authUser(email, password: pass, withCompletionBlock: { (error, authdata) -> Void in
            
            if(error == nil ){
                self.authData = authdata;
                authdataid = authdata.uid;
                self.loggedIn = true;
                print (authdata)
                
            }else{
                
                let alert = UIAlertView(
                    title: NSLocalizedString("Error", comment: "No such account exist. Check your username or password or Sign up first"),
                    message: "No such account exist. Check your username or password or Sign up first",
                    delegate: nil,
                    cancelButtonTitle: NSLocalizedString("OK", comment: "OK")
                )
                alert.show()
                
                print("error: \(error)");
            }
        })
    }
    
    
    

    
    

    
    func getquery(authData:FAuthData){
        
        var pvdata = self.ItemsRef;
        self.authData = authData
        
        if (pub == true){
            pvdata = ItemsRef.childByAppendingPath("public")
        }else{
            pvdata = ItemsRef.childByAppendingPath("private").childByAppendingPath(self.authData.uid)
        }
        
        pvdata.observeEventType(.Value, withBlock: { snapshot in
            
            if let snap = snapshot.children.allObjects as? [FDataSnapshot]{
                
                for snappy in snap {

                    let image = snappy.value["image1"] as! String
                    let text = snappy.value["text1"] as! String

                    let decodedData = NSData(base64EncodedString: image , options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    let decodedImage = UIImage(data:decodedData!)
                    let newitem = items();
                    newitem.image1 = decodedImage! as UIImage
                    newitem.textmsg = text;
                    queriedlist.append(newitem);
                    
                }
            }
        })
    }


    
    
    func upload(oneitem: NSDictionary, str: String){

        
        currentitem = ItemsRef.ref.childByAppendingPath("public").childByAppendingPath(str);
        
        if (is_private == true){
            is_private = false;
            
            print ("done")
            currentitem = ItemsRef.ref.childByAppendingPath("private").childByAppendingPath(authdataid!).childByAppendingPath(str);
        }
        print (currentitem)
        
        currentitem.setValue(oneitem)
    }
    
    
    
    func createUser(email: String, pass:String){
        print (pass)
        ItemsRef.createUser(email, password: pass,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                }
        })
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
}
