//
//  FilterDetailsViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/24.
//

import UIKit

class FilterDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var fDetailsTableView: UITableView!
    var fDetailsCollection = [CocktailsProperties]()
    var fDetailsURL: String?
    var chosenFilter: String?
    var chosenIngredient: String?
    var chosenAlcoholic: String?
    var chosenGlass: String?
    var chosenCategory: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        print("fDetailsURL")
        downloadCategoriesDetaillsJSON {
            print("fDetailsURL: \(self.fDetailsURL!)")
            print("chosenFilter: \(self.chosenFilter!)")
            self.fDetailsTableView.reloadData()
           
        }
        
        fDetailsTableView.delegate = self
        fDetailsTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fDetailsCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = fDetailsTableView.dequeueReusableCell(withIdentifier: "fDetailsCustomCell") as! FilterDetailsCustomTableViewCell
        
        switch chosenFilter
        {
            case "Categories":
                chosenCategory = fDetailsCollection[indexPath.row].strCategory!
                cell.filterDetailsLbl?.text = fDetailsCollection[indexPath.row].strCategory!
                //cell.filterDetailsIMG.image = UIImage(named: "\(fDetailsCollection[indexPath.row].strDrink!)IMG")
                
            case "Glasses":
                chosenGlass = fDetailsCollection[indexPath.row].strGlass!
                cell.filterDetailsLbl?.text = fDetailsCollection[indexPath.row].strGlass!
                //cell.filterDetailsIMG.image = UIImage(named: "\(fDetailsCollection[indexPath.row].strDrink!)IMG")
                
            case "Ingredients":
                chosenIngredient = fDetailsCollection[indexPath.row].strIngredient1!
                cell.filterDetailsLbl?.text = fDetailsCollection[indexPath.row].strIngredient1!
                //cell.filterDetailsIMG.image = UIImage(named: "\(fDetailsCollection[indexPath.row].strDrink!)IMG")
                
            case "Alcoholic":
                chosenAlcoholic = fDetailsCollection[indexPath.row].strAlcoholic!
                cell.filterDetailsLbl?.text = fDetailsCollection[indexPath.row].strAlcoholic!
                //cell.filterDetailsIMG.image = UIImage(named: "\(fDetailsCollection[indexPath.row].strDrink!)IMG")
            default:
                print("No filter was chosen")
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        performSegue(withIdentifier: "choiceToDetailsSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let destination = segue.destination as? FilterChoiceViewController
        {
            switch chosenFilter
            {
                case "Categories":
                    destination.chosenCategory = fDetailsCollection[(fDetailsTableView.indexPathForSelectedRow?.row)!].strCategory
                    destination.chosenFilter = chosenFilter
                    
                case "Glasses":
                    destination.chosenGlass = fDetailsCollection[(fDetailsTableView.indexPathForSelectedRow?.row)!].strGlass
                    destination.chosenFilter = chosenFilter
                    
                case "Ingredients":
                    destination.chosenIngredient = fDetailsCollection[(fDetailsTableView.indexPathForSelectedRow?.row)!].strIngredient1
                    destination.chosenFilter = chosenFilter
                    
                case "Alcoholic":
                    destination.chosenAlcoholic = fDetailsCollection[(fDetailsTableView.indexPathForSelectedRow?.row)!].strAlcoholic
                    destination.chosenFilter = chosenFilter
                   
                default:
                    print("No filter was chosen")
                
            }
           
        }
    }

    
    func downloadCategoriesDetaillsJSON(completed: @escaping () -> ())
    {
    
    //print("The Query URL is: \(queryURL)")
    let url = URL(string: (fDetailsURL)!)!
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
            self.fDetailsCollection = try jsonDecoder.decode(Cocktails.self, from: unwrappedData).drinks
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
