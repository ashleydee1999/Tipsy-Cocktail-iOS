//
//  FilterChoiceViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/27.
//

import UIKit

class FilterChoiceViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var cocktailFilterChoiceCollectionView: UICollectionView!
    var cocktailCollection = [CocktailsProperties]()
    var chosenFilter: String?
    var chosenIngredient: String?
    var chosenAlcoholic: String?
    var chosenGlass: String?
    var chosenCategory: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        downloadCocktailsJSON
        {
            print("All cocktails downloaded")
            self.cocktailFilterChoiceCollectionView.reloadData()
            //print(self.cocktailCollection)
        }
        cocktailFilterChoiceCollectionView.dataSource =  self
        cocktailFilterChoiceCollectionView.delegate = self
        cocktailFilterChoiceCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cocktailCollection.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = cocktailFilterChoiceCollectionView.dequeueReusableCell(withReuseIdentifier: "filterChoiceCellcocktailID", for: indexPath) as! filterChoiceCollectionViewCell

        cell.fChoiceLbl.text = cocktailCollection[indexPath.row].strDrink!.uppercased()
        
        cell.fChoiceIMG.layer.cornerRadius = cell.fChoiceIMG.frame.size.width/2
        cell.fChoiceIMG.clipsToBounds = false
        cell.fChoiceIMG.layer.shadowColor = UIColor.black.cgColor
        cell.fChoiceIMG.layer.shadowOpacity = 0.4
        cell.fChoiceIMG.layer.shadowOffset =  CGSize(width: 2, height: 2)
        cell.fChoiceIMG.layer.shadowRadius = 7
        cell.fChoiceIMG.downloaded(from: (cocktailCollection[indexPath.row].strDrinkThumb!))
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 216)
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 13, bottom: 0, right: 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let destination = storyboard?.instantiateViewController(identifier: "CocktailDetailsViewController") as? CocktailDetailsViewController
        destination!.cocktailID = cocktailCollection[indexPath.row].idDrink
        self.navigationController?.pushViewController(destination!, animated: true)
    }
  
    func downloadCocktailsJSON(completed: @escaping () -> ())
     {
        var url:URL?
        
        switch chosenFilter!
        {
            case "Categories":
                let yourString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\((chosenCategory)!)"
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "_").trimmingCharacters(in: .whitespacesAndNewlines)
                url = URL(string: urlNew)!
                
            case "Glasses":
                let yourString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=\((chosenGlass)!)"
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "_").trimmingCharacters(in: .whitespacesAndNewlines)
                url = URL(string: urlNew)!
                
            case "Ingredients":
                let yourString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=\((chosenIngredient)!)"
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "+").trimmingCharacters(in: .whitespacesAndNewlines)
                url = URL(string: urlNew)!
                
            case "Alcoholic":
                let yourString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=\((chosenAlcoholic)!)"
                let urlNew:String = yourString.replacingOccurrences(of: " ", with: "_").trimmingCharacters(in: .whitespacesAndNewlines)
                url = URL(string: urlNew)!
                
            default:
                    print("No filter was chosen")
            
        }

         let urlSession = URLSession.shared
         let urlRequest = URLRequest(url: url!)

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
                self.cocktailCollection = try jsonDecoder.decode(Cocktails.self, from: unwrappedData).drinks
                    DispatchQueue.main.async
                    {
                        completed()
                    }
            }
            catch
            {
                print(error)
            }
         }.resume()
     }

}
