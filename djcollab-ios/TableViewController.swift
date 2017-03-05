//
//  TableViewController.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tracks:[SPTPartialTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dismissKeyboardOnTap()
        
        search(query:  "Porter Robinson")
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }

        cell.titleLabel?.text = tracks[indexPath.row].name
        
        let artists:[SPTPartialArtist]! = tracks[indexPath.row].artists as! [SPTPartialArtist]
        
        var artistString = ""
        
        for artist in artists{
            artistString += (artist.name + ", ")
        }
        
        artistString = artistString.substring(to: artistString.index(artistString.endIndex, offsetBy: -2))
        
        let imageURL = tracks[indexPath.row].album?.smallestCover.imageURL
        
        cell.authorLabel.text = artistString
        
        cell.artImageView.kf_setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = SPTAudioStreamingController.sharedInstance()
        let url = "\((tracks[indexPath.row].playableUri)!)"
        player?.playSpotifyURI(url, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if let _err = error{
                print(_err)
            }
        })
    }
    
    // MARK: - UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            search(query: query)
            searchBar.resignFirstResponder()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func search(query:String){
        SPTSearch.perform(withQuery: query, queryType: .queryTypeTrack, accessToken: nil) { (error, resp) in
            let page = resp as! SPTListPage
            self.tracks = page.items as! [SPTPartialTrack]? ?? []
            self.tableView.reloadData()
            
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
