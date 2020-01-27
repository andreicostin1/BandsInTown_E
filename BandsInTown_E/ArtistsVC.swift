//
//  ArtistsVC.swift
//  BandsInTown_E
//
//  Created by Andrei Costin on 1/6/20.
//  Copyright © 2020 Andrei Costin. All rights reserved.
//


import UIKit

// struct for parsing input array
struct rep: Decodable {
    let artists: [artist]
}

// struct for data from API
struct artist: Decodable {
    let id: Int
    let name: String
    let tracker_count: Int
    let on_tour: Bool
    let artist_url: String
    let track_url: String
    let image_url: String
}

// view controller for artist listview from api 
class ArtistsVC: UIViewController {
    
    // outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToArtist(segue: UIStoryboardSegue) {}
    
    // globals
    var artistArr = [artist]()
    var searchArtist = [artist]()
    var searching = false
    var send: artist?
    
    // View did load, setup
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    // Parses The JSON
    func getData(){
        //defines API URL with varibales for querry API
        let urlString =  "https://search.bandsintown.com/search?query=%7B%0A%22entities%22%3A%20%5B%7B%0A%22type%22%3A%20%22artist%22%0A%7D%5D%0A%7D"
        // 1
        guard let url = URL(string: urlString) else { return }
        
        // auth for API
        var request = URLRequest(url: url)
        request.setValue("6RLeFqUfcN6SQnnQgPCfq3OozzS6YfTI3zIuDvTd", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                //Decode data
                let inp = try JSONDecoder().decode(rep.self, from: data)
                self.artistArr = inp.artists
                DispatchQueue.main.async{
                    // reload table after getting data
                    self.tableView.reloadData()
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            // 5
        }.resume()
    }
}
// extension to set up data table
extension ArtistsVC: UITableViewDataSource, UITableViewDelegate {
    
    // Function to get length of table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchArtist.count
        } else {
            return artistArr.count
        }
    }
    
    // function to get cells in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCustomCell
        if searching {
            cell.setArtist(ar: searchArtist[indexPath.row])
        } else {
            cell.setArtist(ar: artistArr[indexPath.row])
        }
        return cell
    }
    // function for cell clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            send = searchArtist[indexPath.row]
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "showArtist", sender: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            send = artistArr[indexPath.row]
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "showArtist", sender: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // func for sending data to other VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ArtistOutVC
        vc.rec = self.send
    }
}

// extension for searching
extension ArtistsVC: UISearchBarDelegate {
    // func for search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // filtering
        searchArtist = artistArr.filter({inp -> Bool in
            guard let text = searchBar.text else {return false}
            if(text == "") {return true}
            return inp.name.contains(text)
        })
        searching = true
        tableView.reloadData(); // reload data in listview to match search params
    }
    
    // cancel button 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
