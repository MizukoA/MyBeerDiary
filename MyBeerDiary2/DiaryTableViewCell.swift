//
//  DiaryTableViewCell.swift
//  MyBeerDiary2
//
//  Created by 青柳瑞子 on 2018/08/30.
//  Copyright © 2018年 青柳瑞子. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabei: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var drinkLabel: UILabel!
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
