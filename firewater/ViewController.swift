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
    

    static var BASE_URL = "https://koirala.firebaseio.com"
    let stuffItemsRef = Firebase(url: BASE_URL)
    
    
    override func viewDidLoad() {
        doQuery();
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        doQuery();
        mcollectionView.reloadData();
        super.viewDidAppear(true);
    }

    

    func doQuery(){
        
        print ("what?")
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
                    print (queriedlist.count)
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
        
    //    print (queriedlist.count)
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


