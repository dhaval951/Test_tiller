//
//  ActivityTableViewCell.swift
//  menuDemo
//
//  Created by Vivek Purohit on 06/09/17.
//  Copyright © 2017 zealous. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell
{

    //MARK: -IBOutlet
    
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var lblVoted: UILabel!
    @IBOutlet weak var btnVotedBool: UIButton!
    @IBOutlet weak var lblVotedOn: UILabel!
    @IBOutlet weak var lblAct: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
