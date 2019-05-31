//
//  ViewFamilyTableViewCell.swift
//  ExpenseManager
//
//  Created by Dhruv Patel on 17/5/19.
//  Copyright © 2019 Dhruv Patel. All rights reserved.
//

import UIKit

class ViewFamilyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
