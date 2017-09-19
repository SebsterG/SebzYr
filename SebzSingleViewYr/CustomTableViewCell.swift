//
//  CustomTableViewCell.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 11.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var tempLabel:UILabel!
    @IBOutlet var rainLabel:UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var windDirection: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
