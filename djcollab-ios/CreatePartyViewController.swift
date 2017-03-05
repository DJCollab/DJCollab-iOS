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
                self.performSegue(withIdentifier: "toHostPlaylistView", sender: self)
            }
        
        
        form = Section("")
            <<< createClaimRow
            <<< nameRow
            +++ Section("")
            <<< buttonRow
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
