//
//  ArtistOutVC.swift
//  BandsInTown_E
//
//  Created by Andrei Costin on 1/8/20.
//  Copyright © 2020 Andrei Costin. All rights reserved.
//

import Foundation
import UIKit

class ArtistOutVC: UIViewController {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var eventCount: UILabel!
    
    var rec: artist?
    var aInfo: artistInfo?
    
    struct op: Decodable {
        var display_listen_unit:Bool
    }
    
    struct artistInfo: Decodable {
        var id: String
        var name: String
        var url: String
        var mbid: String
        var options: op
        var image_url: String
        var thumb_url: String
        var facebook_page_url: String
        var tracker_count: Int
        var upcoming_event_count: Int
    }
    
    override func viewDidLoad() {
        self.getData()
        super.viewDidLoad()
        
    }
    
    /// Parses The JSON
    func getData(){
        //defines API URL
        let urlString =  "https://rest.bandsintown.com/artists/" + rec!.name.replacingOccurrences(of: " ", with: "") + "?app_id=test"
        // Asynchronous Http call to your api url, using URLSession:
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            do {
                self.aInfo = try JSONDecoder().decode(artistInfo.self, from: data!)
                DispatchQueue.global().async {
                    let url = URL(string: self.aInfo!.image_url)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async{
                        self.profile.image = UIImage(data: data!)
                        self.name.text = self.aInfo?.name;
                        self.count.text = "Tracker count: " + String(self.aInfo!.tracker_count)
                        self.eventCount.text = "Event Count: " + String(self.aInfo!.upcoming_event_count)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    }
}
