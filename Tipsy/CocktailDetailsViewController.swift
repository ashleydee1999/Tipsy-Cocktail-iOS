//
//  CocktailDetailsViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/19.
//

import UIKit

class CocktailDetailsViewController: UIViewController
{

    @IBOutlet weak var cocktailNameLbl: UILabel!
    @IBOutlet weak var favouritesIMG: UIImageView!
    @IBOutlet weak var cocktailIMG: UIImageView!
    @IBOutlet weak var cocktailInfoLbl: UILabel!
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
