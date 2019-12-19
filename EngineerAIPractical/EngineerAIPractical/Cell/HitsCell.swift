//
//  HitsCell.swift
//  EngineerAIPractical
//
//  Created by PCQ111 on 19/12/19.
//  Copyright © 2019 PCQ111. All rights reserved.
//

import UIKit

class HitsCell: UITableViewCell {

    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet weak var displaySwitch: UISwitch!
    
    var postHit : HitsList? {
        didSet {
            self.labelTitle.text = postHit?.title ?? ""
            if let date =  postHit?.created_at {
                labelDate.text = Util.changeDateStringFormat(dateString: date)
            }
            self.displaySwitch.isOn = postHit?.isActive ?? false 
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
