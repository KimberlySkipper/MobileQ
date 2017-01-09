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
   
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
