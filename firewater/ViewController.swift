//
//  ViewController.swift
//  firewater
//
//  Created by Preksha Koirala on 4/5/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import UIKit
import Firebase


class items{
    var image1: UIImage?
    var textmsg: String?
}
var queriedlist = [items]();

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var mcollectionView: UICollectionView!
    var querieddict = [String: [items]]()
    var authData: FAuthData!
    var authdataid: String?

    static var BASE_URL = "https://koirala.firebaseio.com"
    let stuffItemsRef = Firebase(url: BASE_URL)
    
   
    
    
    override func viewDidLoad() {
        doLogin()
        
        doQuery();
        
        stuffItemsRef.observeAuthEventWithBlock({ authData in
            if authData != nil{
                self.getprivatequery(authData);
                
            }else{
            
                print("not authenticated yet");
            }
        })
        
        
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        doQuery();
        mcollectionView.reloadData();
        super.viewDidAppear(true);
    }
    
    

    
    
    
    
    
    func doLogin( ){
    
        stuffItemsRef.authUser("myemailid@gmail.com", password: "pass", withCompletionBlock: { (error, authdata) -> Void in
            
            if(error == nil ){
                self.authData = authdata;
                print(self.authData)
                self.authdataid = authdata.uid;
                
                
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
    
    
    
    
    
    
    func getprivatequery(authData:FAuthData){
        
       
        
        var pvdata = self.stuffItemsRef;
        self.authData = authData
        pvdata = stuffItemsRef.childByAppendingPath("privatedata").childByAppendingPath(self.authData.uid)
        
        print(pvdata)
        
        pvdata.observeEventType(.Value, withBlock: { snapshot in
            print ("printing")
            
            print (pvdata.valueForKey("text"));
         
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


