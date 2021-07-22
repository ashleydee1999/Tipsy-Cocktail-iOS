//
//  CocktailDetailsViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/19.
//

import UIKit

class CocktailDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientsCustomCell") as! ingredientsCustomTableViewCell
        
        cell.ingredientsLbl?.text = ingredientsName[indexPath.row]
        cell.measurementsLbl?.text = ingredientsMeasure[indexPath.row]
        
        
        print("These are: \(ingredientsName[indexPath.row]): \(ingredientsMeasure[indexPath.row])")
        
        return cell
    }
    

    @IBOutlet weak var cocktailNameLbl: UILabel!
    @IBOutlet weak var favouritesIMG: UIImageView!
    @IBOutlet weak var cocktailIMG: UIImageView!
    @IBOutlet weak var cocktailInfoLbl: UILabel!
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var cocktailID: String?
    var cocktailDetailsCollection = [SearchCocktailsProperties]()
    var simpleArray: SearchCocktailsProperties?
    var ingredientsName: [String] = []
    var ingredientsMeasure: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //print("The received ID is \(cocktailID!)")
        
        downloadCocktailDetaillsJSON
        {
            //print("The Cocktail Details are sorted")
            self.simpleArray = self.cocktailDetailsCollection[0]
            self.setUp()
            
            self.ingredientsTableView.reloadData()
            
        }
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
    }
    func setUp()
    {
        self.cocktailNameLbl.text = self.simpleArray?.strDrink
        self.cocktailIMG.downloaded(from: self.simpleArray?.strDrinkThumb ?? "")
        
        let mirror = Mirror(reflecting: simpleArray!)
        
        for child in mirror.children
        {
           
            let theValue = child.value as? String
            if child.label!.contains("Ingredient") && theValue != nil
            {
                ingredientsName.append("\((theValue)!)")
            }
        }
        
        for child in mirror.children
        {
            let theValue = child.value as? String
            
            if (child.label!.contains("Measure")) && theValue != nil
            {
                ingredientsMeasure.append(theValue ?? "")
            }
            
        }
        
        self.ingredientsTableView.reloadData()
        
    }
    
    func downloadCocktailDetaillsJSON(completed: @escaping () -> ())
    {
    let queryURL = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(cocktailID!)"
    
    //print("The Query URL is: \(queryURL)")
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
