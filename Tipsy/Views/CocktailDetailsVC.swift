//
//  CocktailDetailsViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/19.
//

import UIKit
import Foundation
import CoreData

class CocktailDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var cocktailNameLbl: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var cocktailIMG: UIImageView!
    @IBOutlet weak var cocktailInfoLbl: UILabel!
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [FavouriteCocktailsCD]()
    
    var cocktailID: String?
    var cocktailDetailsCollection = [CocktailsProperties]()
    var simpleArray: CocktailsProperties?
    var ingredientsName: [String] = []
    var ingredientsMeasure: [String] = []
    var ingredientsMeasureBalanced: [String] = []
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
        { [self] in
            //print("The Cocktail Details are sorted")
            self.simpleArray = self.cocktailDetailsCollection[0]
            self.setUp()
            favBtnStatus((simpleArray!.idDrink)!)
            self.ingredientsTableView.reloadData()
            
        }
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ingredientsMeasure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientsCustomCell") as! ingredientsCustomTableViewCell
        
        cell.cocktailIMG.image = UIImage(named: ingredientsName[indexPath.row])
        cell.ingredientsLbl?.text = ingredientsName[indexPath.row]
        cell.measurementsLbl?.text = ingredientsMeasure[indexPath.row]
        
        
        return cell
    }
    
    @IBAction func favouritesTapped(_ sender: Any)
    {
        let checkRecord = checkIfExists((simpleArray!.idDrink)!)
        
        if checkRecord == false
        {
            addFavouriteCocktail((simpleArray?.idDrink)!)
            self.favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            let alert  = UIAlertController(title: "Succesfully Addded", message: "\((simpleArray?.strDrink)!) added to your favourites!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            let alert  = UIAlertController(title: "Existing Item", message: "Already in favourites!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.deleteFavourite((self!.simpleArray?.idDrink)!)
                self!.favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                let notifier  = UIAlertController(title: "Succesfully Removed", message: "\((self!.simpleArray?.strDrink)!) removed from your favourites!", preferredStyle: .alert)
                notifier.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self!.present(notifier, animated: true)
                
            }))
            self.present(alert, animated: true)
        }
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
        
        /*
            Compare the sizes of the ingredients array vs measures array
            The measures array may be smaller than the ingredients array, because the last ingredient hasn't got a measure
         */
        if ingredientsName.count != ingredientsMeasure.count
        {
           
            for n in ingredientsMeasure.count ..< ingredientsName.count
            {
                ingredientsMeasure.append("N/A")
            }
           
        }
        
        self.ingredientsTableView.reloadData()
        
    }
    
    func favBtnStatus( _ itemID: String)
    {
        let checkRecord = checkIfExists((simpleArray!.idDrink)!)
        
        if checkRecord == false
        {
            self.favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else
        {
            self.favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
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
    
    
    //Core Data Management
    
    func addFavouriteCocktail( _ itemID: String)
    {
        let newItem = FavouriteCocktailsCD(context: context) //The context from line 20
        
        newItem.idFavDrink = itemID
        
        do
        {
            try context.save()
            print("Favourite Cocktail Saved")
        }
        catch
        {
            print("Save Error: \(error.localizedDescription)")
        }
       
    }
    
    func checkIfExists( _ itemID: String) -> Bool
    {
        var numRecords:Int = 0
        
        do
        {
            let request: NSFetchRequest<FavouriteCocktailsCD> = FavouriteCocktailsCD.fetchRequest()
            request.predicate = NSPredicate(format: "idFavDrink == %@", itemID)
        
            numRecords = try context.count(for: request)
            print("We're counting our items: \(numRecords)")
        }
        catch
        {
            print("Error in checking items: \(error.localizedDescription)")
        }
        if numRecords == 0
        {
            return false
        }
        else
        {
            return true
            
        }
    }
    
    func deleteFavourite( _ itemID: String)
    {
        do{
            let request: NSFetchRequest<FavouriteCocktailsCD> = FavouriteCocktailsCD.fetchRequest()
            request.predicate = NSPredicate(format: "idFavDrink == %@", itemID)
            
            models = try context.fetch(request)
        }
       catch
        {
           
       }

        context.delete(models[0])
        
        do
        {
            try context.save()
    
        }
        catch
        {
            print("Save Error: \(error.localizedDescription)")
        }
    }
}
