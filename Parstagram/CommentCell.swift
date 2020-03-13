//
//  CommentCell.swift
//  Parstagram
//
//  Created by RAUL RIVERO RUBIO on 3/12/20.
//  Copyright © 2020 codepath-cit238b-spring2020. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UIView!
    @IBOutlet weak var commentLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
