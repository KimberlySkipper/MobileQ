//
//  TableViewCell.swift
//  MobileQ
//
//  Created by Kimberly Skipper on 1/5/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class QueueTableViewCell: UITableViewCell
{
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
   // @IBOutlet weak var briefDescTextField: UITextField!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
