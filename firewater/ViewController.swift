//
//  ViewController.swift
//  firewater
//
//  Created by Preksha Koirala on 4/5/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import UIKit
import Firebase

var authdataid: String?
var teststring: String?

class items{
    var image1: UIImage?
    var textmsg: String?
}
var queriedlist = [items]();

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var pri_pub: UIBarButtonItem!
    @IBOutlet var mcollectionView: UICollectionView!
    var querieddict = [String: [items]]()
    var authData: FAuthData!
    var pub: Bool!
    

    static var BASE_URL = "https://koirala.firebaseio.com"
    let stuffItemsRef = Firebase(url: BASE_URL)
    
   
    
    
    override func viewDidLoad() {
   
         super.viewDidLoad();
        doLogin()
        
        
        pub = true;
        stuffItemsRef.observeAuthEventWithBlock({ authData in
            if authData != nil{
                self.getquery(authData);
                authdataid = authData.uid;

                
                 //self.doQuery();
                
            }else{
            
                print("not authenticated yet");
            }
        })
        
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        
        doLogin();
    }
    
    override func viewDidAppear(animated: Bool) {
        //doQuery();
        mcollectionView.reloadData();
        super.viewDidAppear(true);
    }
    
    

    @IBAction func showid(sender: AnyObject) {
        
        
        //print (authdataid)
    }
    
    
    @IBAction func private_public(sender: AnyObject) {
        queriedlist = [items]();
        getquery(self.authData)
        mcollectionView.reloadData();
        
        if (pub == true){
            
            
            pub = false;
            pri_pub.title = "See Private Items";
            
        }else{
            pub = true;
            pri_pub.title = "See Public Items";
            
        }
        
        
        
        
    }
   
    
    
    
    func  doLogin( ){
    
        stuffItemsRef.authUser("another@gmail.com", password: "pass", withCompletionBlock: { (error, authdata) -> Void in
            
            if(error == nil ){
                self.authData = authdata;

                authdataid = authdata.uid;

            }else{
                print("error: \(error)");
            }
            
            
            
//            self.stuffItemsRef.childByAppendingPath("users")
//                .childByAppendingPath("authData.uid")
//                .setValue(["provider": authData.provider, "displayName": "myemailid"], with completionBlock: {(error,auth) -> Void in
////                        cb(authData)
//                })
//            
        })

    }
    

    func getquery(authData:FAuthData){
        
       
        
        var pvdata = self.stuffItemsRef;
        self.authData = authData
        
        if (pub == true){
             pvdata = stuffItemsRef.childByAppendingPath("public")
        }else{
        pvdata = stuffItemsRef.childByAppendingPath("private").childByAppendingPath(self.authData.uid)
        }
        print(pvdata)
        
        pvdata.observeEventType(.Value, withBlock: { snapshot in
          //  print ("printing")
            
            if let snap = snapshot.children.allObjects as? [FDataSnapshot]{
                
                for snappy in snap {
                    
                   //print(snappy.key)
                    let image = snappy.value["image1"] as! String
                    
                    
                   // print (image)
                    let text = snappy.value["text1"] as! String
                    print (text)
                    
                    
                    let decodedData = NSData(base64EncodedString: image as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    let decodedImage = UIImage(data:decodedData!)
                    
                    
                    
                    
                    
                    
                    var newitem = items();
                    newitem.image1 = decodedImage! as UIImage
                    newitem.textmsg = text;
                    queriedlist.append(newitem);
                    
                    dispatch_async(dispatch_get_main_queue()) { // 2
                        // self.fadeInNewImage(overlayImage) // 3
                        self.mcollectionView.reloadData();
                    }
                                        
                }
                
                
            }
            
            
           // print (snapshot.valueForKey("text"));
         
        })
        
    }
    
    
    
    
    
    
    
    
    

    

    func doQuery(){
        
      //  print ("what?")
        stuffItemsRef.observeEventType(.Value, withBlock: { snapshot in
            let enumerator = snapshot.children
            queriedlist = [items]();
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                
                var newitem = items()
                
                if let imagestr = rest.value.objectForKey("image1"){
                    let imagerealstr = imagestr as! String
                    let decodedData = NSData(base64EncodedString: imagerealstr as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    let decodedImage = UIImage(data:decodedData!)
                    newitem.image1 = decodedImage! as UIImage
                    
                }
    
                
                
                
                if let str = rest.value.objectForKey("text1"){
                    let realstring = str as! String
                    newitem.textmsg = realstring;
                    
                    queriedlist.append(newitem);
                 //   print (queriedlist.count)
                    
                    dispatch_async(dispatch_get_main_queue()) { // 2
                       // self.fadeInNewImage(overlayImage) // 3
                        self.mcollectionView.reloadData();
                    }
                }
         
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    
    }
    
    
    
    
    
    
    
    
    
    

    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      //  print (queriedlist.count)
        return queriedlist.count;
        
    }
    
   
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectioncell", forIndexPath: indexPath) as! collectionviewcell
        
         var oneitem = queriedlist[indexPath.row];
        
        cell.mImageView.image = oneitem.image1;
        cell.mLabel.text = oneitem.textmsg;
        return cell
        
    }
    
    
    
}


