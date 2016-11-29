//
//  ToDoCell.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 29-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
    @IBOutlet weak var todoNote: UILabel!
    @IBOutlet weak var checkSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
