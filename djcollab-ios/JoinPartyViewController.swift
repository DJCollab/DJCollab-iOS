//
//  JoinPartyViewController.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit
import Eureka

class JoinPartyViewController: FormViewController {
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameRow = TextRow()
            { row in
                row.title = "Party Name"
        }
        
        let buttonRow = ButtonRow()
            {
                $0.title = "Join Party"
            }
            .onCellSelection
            { (cell, row) in
                if(nameRow.value == nil || nameRow.value == ""){
                    self.alertInvalidInput("Error", message: "Please provide a party name")
                }
                RestClient.PartyByName(name: nameRow.value!, { (success, statusCode, json) in
                    if(success){
                        self.id = json!["id"]! as! Int
                        self.performSegue(withIdentifier: "toJoinPlaylistView", sender: self)
                    }
                    else{
                        self.alertInvalidInput("Error", message: "Please try again")
                    }
                })
            }
        
        
        form = Section("")
            <<< nameRow
            +++ Section("")
            <<< buttonRow
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? SongFeedViewController {
            vc.id = id
        }
    }


}
