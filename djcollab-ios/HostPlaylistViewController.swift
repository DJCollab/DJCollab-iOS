//
//  HostPlaylistViewController.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit
import Gloss

class HostPlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchTableViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var tracks:[SPTPartialTrack] = []
    
    var id: Int = 0
    
    let player = SPTAudioStreamingController.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrack))
        
        RestClient.Queue(partyID: id) { (success, statusCode, json) in
            if(success){
                var uris:[String] = []
                for item in json!["items"]! as! [JSON] {
                    uris.append(item["song_id"] as! String)
                }
                
                SPTTrack.tracks(withURIs: uris.map({ URL(string: $0)! }), accessToken: nil, market: nil) { (error, resp) in
                    if(resp != nil){
                        let trackArr = resp as! [SPTTrack]
                        self.tracks = trackArr
                        self.tableView.reloadData()
                        self.setCurrentPlaying()
                    }
                    self.player?.playSpotifyURI("\((self.tracks.first?.playableUri)!)", startingWith: 0, startingWithPosition: 0, callback: { (err) in
                    })
                }
                
            }else {
                self.alertInvalidInput("Error", message: "")
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (t) in
            RestClient.Queue(partyID: self.id) { (success, statusCode, json) in
                if(success){
                    var uris:[String] = []
                    for item in json!["items"]! as! [JSON] {
                        uris.append(item["song_id"] as! String)
                    }
                    
                    if(uris.count <= self.tracks.count){
                        return
                    }
                    
                    SPTTrack.tracks(withURIs: uris.map({ URL(string: $0)! }), accessToken: nil, market: nil) { (error, resp) in
                        if(resp != nil){
                            let trackArr = resp as! [SPTTrack]
                            self.tracks = trackArr
                            self.tableView.reloadData()
                            self.setCurrentPlaying()
                        }
                    }
                }
            }
        }
    }
    
    
    func addTrack() {
        let vc = UIStoryboard(name: "SearchView", bundle: nil).instantiateInitialViewController() as? SearchTableViewController
        vc?.delegate = self
        present(vc!, animated: true, completion: nil)
    }
    
    // MARK: - Search View Delegate
    func didSelectTrack(track: SPTPartialTrack) {
        tracks.append(track)
        tableView.reloadData()
        RestClient.AddSong(partyID: id, songURI: "\(track.playableUri!)") { (_, _, _) in }
        dismiss(animated: true, completion: nil)
    }
    
    func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func prevTapped(_ sender: UIButton) {
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        if(player?.playbackState?.isPlaying ?? false){
            player?.setIsPlaying(false, callback: { (err) in
                print(err)
            })
            sender.setTitle("Play", for: .normal)
        }else{
            player?.setIsPlaying(true, callback: { (err) in
            })
            sender.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        let old = "\((self.tracks.first?.playableUri)!)"
        RestClient.DeleteSong(partyID: id, songURI: old) { (_, _, _) in
        }
        
        tracks.remove(at: 0)
        setCurrentPlaying()
        self.player?.playSpotifyURI("\((self.tracks.first?.playableUri)!)", startingWith: 0, startingWithPosition: 0, callback: { (err) in
        })
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
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
