//
//  ShowAllNewsTableViewCell.swift
//  LameLab
//
//  Created by user on 05.04.15.
//  Copyright (c) 2015 Goxit Design. All rights reserved.
//

import UIKit

class ShowAllNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
