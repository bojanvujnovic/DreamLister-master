//
//  ItemCell.swift
//  DreamLister
//
//  Created by Mac on 2/18/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item)  {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumbImageView.image = item.toImage?.image as! UIImage?
    }
    
}
