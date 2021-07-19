//
//  customTableViewCell.swift
//  Breaking Bad Mini
//
//  Created by IACD-Air-11 on 2021/07/04.
//

import UIKit

class ingredientsCustomTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var cocktailIMG: UIImageView!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var measurementsLbl: UILabel!
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
