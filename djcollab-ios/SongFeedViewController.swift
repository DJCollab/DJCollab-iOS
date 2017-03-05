//
//  SongFeedViewController.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit
import Kingfisher

class SongFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchTableViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tracks:[SPTPartialTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrack))
        
        let sArr = ["spotify:track:58s6EuEYJdlb0kO7awm3Vp"].map({URL(string: $0)!})
        
        SPTTrack.tracks(withURIs: sArr, accessToken: nil, market: nil) { (error, resp) in
            if(resp != nil){
                let trackArr = resp as! [SPTTrack]
                self.tracks = trackArr
                self.tableView.reloadData()
            }
        }
    }

    func addTrack() {
        let vc = UIStoryboard(name: "SearchView", bundle: nil).instantiateInitialViewController() as? SearchTableViewController
        vc?.delegate = self
        present(vc!, animated: true, completion: nil)
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
        
        cell.artImageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    // MARK: - Search View Delegate
    func didSelectTrack(track: SPTPartialTrack) {
        tracks.append(track)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
