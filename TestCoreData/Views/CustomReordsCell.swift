//
//  CustomReordsCell.swift
//  SwiftNetworkApp
//
//  Created by r.f.kumar.mishra on 18/07/18.
//  Copyright © 2018 Kumar Mishra, R. F. All rights reserved.
//

import UIKit

class CustomReordsCell: UITableViewCell {
    
    @IBOutlet weak var placesView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
