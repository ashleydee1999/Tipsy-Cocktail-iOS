//
//  FilterDetailsCustomTableViewCell.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/24.
//

import UIKit

class FilterDetailsCustomTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var filterDetailsIMG: UIImageView!
    @IBOutlet weak var filterDetailsLbl: UILabel!
    
    override func   awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
