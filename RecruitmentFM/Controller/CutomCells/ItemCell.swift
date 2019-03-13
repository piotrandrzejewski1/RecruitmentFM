//
//  ItemCell.swift
//  RecruitmentFM
//
//  Created by Piotr Andrzejewski on 11/03/2019.
//  Copyright © 2019 Piotr Andrzejewski. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelUrl: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
