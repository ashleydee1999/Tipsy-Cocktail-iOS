//
//  FavouritesVC.swift
//  FavouritesVC
//
//  Created by Ashley Dube on 2021/08/05.
//

import UIKit

class FavouritesVC: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cdCocktailIDs = [FavouriteCocktailsCD]()
    @IBOutlet weak var favouritesCV: UICollectionView!
    var cocktailCollection = [CocktailsProperties]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.favouritesCV.reloadData()
        getCDCocktails()
        cocktailCollection.removeAll()
        downloadCocktailDetaillsJSON {
            print("Attempting to download cocktails")
            self.favouritesCV.reloadData()
            print("Done downloading cocktails")
        }
        favouritesCV.dataSource =  self
        favouritesCV.delegate = self
        favouritesCV.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cocktailCollection.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = favouritesCV.dequeueReusableCell(withReuseIdentifier: "favouriteCellcocktailID", for: indexPath) as! FavouritesCVCell
        
        cell.favCocktailIMG.downloaded(from: (cocktailCollection[indexPath.row].strDrinkThumb ?? ""))
        cell.favNameLbl.text = (cocktailCollection[indexPath.row].strDrink ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 25, left: 13, bottom: 0, right: 13)
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let destination = storyboard?.instantiateViewController(identifier: "CocktailDetailsViewController") as? CocktailDetailsVC
        destination!.cocktailID = cocktailCollection[indexPath.row].idDrink
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 216)
    }
    // Core Data
    func getCDCocktails()
    {
        do
        {
            cdCocktailIDs = try context.fetch(FavouriteCocktailsCD.fetchRequest())
            
        }
        catch
        {
            print("Error Getting items: \(error.localizedDescription)")
        }
    }
    
    func downloadCocktailDetaillsJSON(completed: @escaping () -> ())
    {
        for i in 0 ..< cdCocktailIDs.count
        {
            let item = cdCocktailIDs[i].idFavDrink as String?
            
            let queryURL = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(item!)"
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
                let list = try jsonDecoder.decode(Cocktails.self, from: unwrappedData).drinks
                //self.cocktailCollection = try jsonDecoder.decode(Cocktails.self, from: unwrappedData).drinks
                self.cocktailCollection.append(contentsOf: list)
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
   
}
