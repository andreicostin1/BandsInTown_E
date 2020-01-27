//
//  MyCustomCell.swift
//  BandsInTown_E
//
//  Created by Andrei Costin on 1/7/20.
//  Copyright © 2020 Andrei Costin. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class MyCustomCell: UITableViewCell {
    
    // global variable of type artist to hold artist value given by listview
    var artist: artist?
    
    // outlets and actions
    @IBOutlet weak var favBut: UIButton! // outlet for fav button to change in other functions
    @IBOutlet weak var label: UILabel!
    // action for fav button
    @IBAction func fav(_ sender: UIButton) {
        // call function to check if exists in memory or not
        // if does, change symbol, if not, leave same
        if(saveOrDelete(ar: artist!, ac: 0)) {
            sender.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    @IBOutlet weak var profile: UIImageView!
    
    // function to set cell, called from listview
    func setArtist(ar: artist) {
        // asigns value of artist to global variable
        artist = ar;
        // chekc if fav or not and set image accordingly
        if(saveOrDelete(ar: artist!, ac: 1)) {
            self.favBut.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
        } else {
            self.favBut.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        DispatchQueue.global().async {
            // get image for profile
            let url = URL(string: ar.image_url)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async{
                // construct cell
                self.profile.image = UIImage(data: data!)
                self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
                self.label.text = ar.name
            }
        }
    }
    
    // function to check if fav cell exists or not
    // **work in progress**
    func saveOrDelete(ar: artist, ac: Int) -> Bool {
        let x: FavoritesVC = FavoritesVC()
        //2
        let fetchRequest = (NSFetchRequest<NSManagedObject>(entityName: "Favorite") as! NSFetchRequest<NSFetchRequestResult>)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        var favSaved: [NSManagedObject]?
        do {
            try favSaved = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            print("fail")
        }
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Favorite",
                                       in: managedContext)!
        let favorite = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        // 3
        favorite.setValue(artist!.id, forKeyPath: "id")
        favorite.setValue(artist!.name, forKeyPath: "name")
        favorite.setValue(artist!.tracker_count, forKeyPath: "tracker_count")
        favorite.setValue(artist!.on_tour, forKeyPath: "on_tour")
        favorite.setValue(artist!.artist_url, forKeyPath: "artist_url")
        favorite.setValue(artist!.track_url, forKeyPath: "track_url")
        favorite.setValue(artist!.image_url, forKeyPath: "image_url")
        
        if !cont(favArr: favSaved!, fav: favorite) {
            // save if favoirte cell does not exist
            if(ac == 1) {
                return true
            } else {
                do {
                    try managedContext.save()
                    x.tableView.reloadData()
                    return true
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
        } else {
            if(ac == 1) {
                return false
            } else {
                // delete if someone unfavorites cell
                managedContext.delete(favorite)
                x.tableView.reloadData()
                return false
            }
        }
        return false
    }
    
    // function to check if object exists in array, checks by value of "id"
    func cont(favArr: [NSManagedObject], fav: NSManagedObject) -> Bool{
        for f in favArr {
            if f.value(forKeyPath: "id") as! Int == fav.value(forKey: "id") as! Int {
                return true
            }
        }
        return false
    }
}
