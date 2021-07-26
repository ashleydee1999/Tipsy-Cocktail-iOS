//
//  CocktailDetailsViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/19.
//

import UIKit
import Foundation

class CocktailDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ingredientsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientsCustomCell") as! ingredientsCustomTableViewCell
        
        cell.cocktailIMG.image = UIImage(named: ingredientsName[indexPath.row])
        cell.ingredientsLbl?.text = ingredientsName[indexPath.row]
        cell.measurementsLbl?.text = ingredientsMeasure[indexPath.row]
        
        
        return cell
    }
    

    @IBOutlet weak var cocktailNameLbl: UILabel!
    @IBOutlet weak var favouritesIMG: UIImageView!
    @IBOutlet weak var cocktailIMG: UIImageView!
    @IBOutlet weak var cocktailInfoLbl: UILabel!
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var cocktailID: String?
    var cocktailDetailsCollection = [CocktailsProperties]()
    var simpleArray: CocktailsProperties?
    var ingredientsName: [String] = []
    var ingredientsMeasure: [String] = []
    var prepInstructions: [String] = []
    
    
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
            //print("The Cocktail Details are sorted")
            self.simpleArray = self.cocktailDetailsCollection[0]
            self.setUp()
            
            self.ingredientsTableView.reloadData()
            
        }
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
    }
    
    func removeWhiteSpaces(str:String) -> String
    {
        var newStr = str
        for i in 0..<str.count{
            let index = str.index(str.startIndex, offsetBy: i)
            print(str[index])
            if str[index] != " "{
                return newStr
            }
            else{
                newStr.remove(at: newStr.startIndex)
            }
        }
        return newStr
    }
    func setUp()
    {
        self.cocktailNameLbl.text = self.simpleArray?.strDrink
        self.cocktailIMG.downloaded(from: self.simpleArray?.strDrinkThumb ?? "")
        self.cocktailInfoLbl.text = "This a/an \((self.simpleArray?.strAlcoholic)!) \((self.simpleArray?.strCategory)!)"
        
        let mirror = Mirror(reflecting: simpleArray!)
        //var rawInstructions: [String] = []
        let theInstructions = self.simpleArray!.strInstructions
        
        
        let splitStringArray = theInstructions!.split(separator: ".").map({ (substring) in
             return String(substring)
         })
        
        prepInstructions = splitStringArray
        

        for i in 0 ..< prepInstructions.count
        {
            prepInstructions[i] = removeWhiteSpaces(str: prepInstructions[i])
        }
        
        instructionsLbl.text = ""
        for i in 0 ..< prepInstructions.count
        {
            instructionsLbl.text?.append("\(i+1): \(prepInstructions[i]) \n\n")
           // print(prepInstructions[i])
        }
        
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
            self.cocktailDetailsCollection = try jsonDecoder.decode(Cocktails.self, from: unwrappedData).drinks
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
