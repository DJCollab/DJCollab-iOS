//
//  CreatePartyViewController.swift
//  djcollab-ios
//
//  Created by Ashley Coleman on 3/4/17.
//  Copyright © 2017 Ashley Coleman. All rights reserved.
//

import UIKit
import Eureka

class CreatePartyViewController: FormViewController {

    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let createClaimRow = SwitchRow()
            {
                $0.title = "Create New"
                $0.value = true
            }
            .onChange { row in
                row.title = (row.value ?? false) ? "Create New" : "Claim Previous"
                row.updateCell()
            }
        
        let nameRow = TextRow()
            { row in
                row.title = "Party Name"
            }
        
        let buttonRow = ButtonRow()
            {
                $0.title = "Create/Claim Party"
            }
            .onCellSelection { (cell, row) in
                if(nameRow.value == nil || nameRow.value == ""){
                    self.alertInvalidInput("Error", message: "Please provide a party name")
                }
                if(createClaimRow.value ?? true){
                    RestClient.CreateParty(name: nameRow.value!, { (success, statusCode, json) in
                        if(success){
                            self.id = json!["id"]! as! Int
                            self.performSegue(withIdentifier: "toHostPlaylistView", sender: self)
                        }
                        else{
                            self.alertInvalidInput("Error", message: "Please try again")
                        }
                    })
                } else {
                    RestClient.PartyByName(name: nameRow.value!, { (success, statusCode, json) in
                        if(success){
                            self.id = json!["id"]! as! Int
                            self.performSegue(withIdentifier: "toHostPlaylistView", sender: self)
                        }
                        else{
                            self.alertInvalidInput("Error", message: "Please try again")
                        }
                    })
                }
            }
        
        
        form = Section("")
            <<< createClaimRow
            <<< nameRow
            +++ Section("")
            <<< buttonRow
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HostPlaylistViewController {
            vc.id = id
        }
    }
    

}
