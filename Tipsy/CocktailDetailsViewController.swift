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
    var cocktailID: String!
    var cocktailDetailsCollection = [SearchCocktailsProperties]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        print("The received ID is \(cocktailID!)")
        downloadCocktailDetaillsJSON
        {
            print("The Cocktail Details are sorted")
            self.cocktailNameLbl.text = self.cocktailDetailsCollection[0].strDrink
            self.cocktailIMG.downloaded(from: self.cocktailDetailsCollection[0].strDrinkThumb)
        }
        
    }
    
    func downloadCocktailDetaillsJSON(completed: @escaping () -> ())
     {
        let queryURL = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(cocktailID!)"
        
        print("The Query URL is: \(queryURL)")
        let url = URL(string: queryURL)!
         let urlSession = URLSession.shared
         let urlRequest = URLRequest(url: url)

         let task = urlSession.dataTask(with: urlRequest)
         {
             data, urlResponse, error in
             
             if let error = error
             {
                 
                 print("Error: \(error.localizedDescription)")
                 return
             }
             
             guard let unwrappedData = data else
             {
                 print("No data")
                 return
             }
             
             
             let jsonDecoder = JSONDecoder()
  
            do
            {
                self.cocktailDetailsCollection = try jsonDecoder.decode(SearchCocktails.self, from: unwrappedData).drinks
                    DispatchQueue.main.async
                    {
                        completed()
                    }
                } catch {
                    print(error)
                }
         }.resume()
        
     }

}
