
//
//  FavoritesVC.swift
//  BandsInTown_E
//
//  Created by Andrei Costin on 1/9/20.
//  Copyright © 2020 Andrei Costin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesVC: UIViewController {
    var send: artist?
    var favArr = [artist]()
    var people = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()  
        //1
       guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
           return
       }
       
       let managedContext =
         appDelegate.persistentContainer.viewContext
       
       //2
       let fetchRequest =
         NSFetchRequest<NSManagedObject>(entityName: "Favorite")
       
       //3
       do {
        people = try managedContext.fetch(fetchRequest)
       } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
       }
    }
}

// extension to set up data table
extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let x = artist(id: person.value(forKeyPath: "id") as! Int, name: person.value(forKeyPath: "name") as! String, tracker_count: person.value(forKeyPath: "tracker_count") as! Int, on_tour: person.value(forKeyPath: "on_tour") as! Bool, artist_url: person.value(forKeyPath: "artist_url") as! String, track_url: person.value(forKeyPath: "track_url") as! String, image_url: person.value(forKeyPath: "image_url") as! String)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCustomCell
        cell.setArtist(ar: x)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             send = favArr[indexPath.row]
             DispatchQueue.main.async{
               self.performSegue(withIdentifier: "showArtistFromFav", sender: nil)
           }
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ArtistOutVC
        vc.rec = self.send
    }
}

