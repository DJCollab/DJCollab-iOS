//
//  HostPlaylistViewController.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit

class HostPlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var tracks:[SPTPartialTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let sArr = ["spotify:track:58s6EuEYJdlb0kO7awm3Vp", "spotify:track:58s6EuEYJdlb0kO7awm3Vp", "spotify:track:58s6EuEYJdlb0kO7awm3Vp", "spotify:track:58s6EuEYJdlb0kO7awm3Vp"].map({URL(string: $0)!})
        
        SPTTrack.tracks(withURIs: sArr, accessToken: nil, market: nil) { (error, resp) in
            if(resp != nil){
                let trackArr = resp as! [SPTTrack]
                self.tracks = trackArr
                self.tableView.reloadData()
                self.setCurrentPlaying()
            }
        }
        
    }
    

    @IBAction func prevTapped(_ sender: UIButton) {
    }
    @IBAction func playTapped(_ sender: UIButton) {
    }
    @IBAction func nextTapped(_ sender: UIButton) {
    }
    
    func setCurrentPlaying(){
        let track = tracks[0]
        titleLabel.text = track.name
        
        let artists:[SPTPartialArtist]! = track.artists as! [SPTPartialArtist]
        
        var artistString = ""
        
        for artist in artists{
            artistString += (artist.name + ", ")
        }
        
        artistString = artistString.substring(to: artistString.index(artistString.endIndex, offsetBy: -2))
        
        artistLabel.text = artistString
        
        let imageURL = track.album?.largestCover.imageURL
        
        imageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        
        let track = tracks[indexPath.row + 1]
        
        cell.titleLabel?.text = track.name
        
        let artists:[SPTPartialArtist]! = track.artists as! [SPTPartialArtist]
        
        var artistString = ""
        
        for artist in artists{
            artistString += (artist.name + ", ")
        }
        
        artistString = artistString.substring(to: artistString.index(artistString.endIndex, offsetBy: -2))
        
        let imageURL = track.album?.smallestCover.imageURL
        
        cell.authorLabel.text = artistString
        
        cell.artImageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
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
