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
            .onCellSelection { (cell, row) in
                self.performSegue(withIdentifier: "toJoinPlaylistView", sender: self)
        }
        
        
        form = Section("")
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
