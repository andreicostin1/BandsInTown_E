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

    var isFav = false
    var artist: artist?
    
    
    @IBOutlet weak var favBut: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBAction func fav(_ sender: UIButton) {
        if(saveOrDelete(ar: artist!, ac: 0)) {
            sender.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    @IBOutlet weak var profile: UIImageView!
    
    
    func setArtist(ar: artist) {
        artist = ar;
        // pic
        if(saveOrDelete(ar: artist!, ac: 1)) {
            self.favBut.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
        } else {
            self.favBut.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        DispatchQueue.global().async {
            let url = URL(string: ar.image_url)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async{
                self.profile.image = UIImage(data: data!)
                self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
                self.label.text = ar.name
            }
        }
    }
    
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
    
    func cont(favArr: [NSManagedObject], fav: NSManagedObject) -> Bool{
        for f in favArr {
            if f.value(forKeyPath: "id") as! Int == fav.value(forKey: "id") as! Int {
                return true
            }
        }
        return false
    }
}
