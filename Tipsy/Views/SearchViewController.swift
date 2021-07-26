//
//  SearchViewController.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/19.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    var cocktailCollection = [CocktailsProperties]()
    @IBOutlet weak var searchCollectionView: UICollectionView!
    let searchController = UISearchController()
    var userQuery: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationItem.searchController = searchController
        searchCollectionView.dataSource =  self
        searchCollectionView.delegate = self
        searchCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    override func viewDidDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchController.searchBar.text else
        {
            return
        }
        setUp(searchText: text)
        
        downloadCocktailsJSON
        {
            print("All cocktails downloaded")
            self.searchCollectionView.reloadData()
        }
        
    }
    
    func setUp(searchText: String)
    {
        userQuery = searchText
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cocktailCollection.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCellcocktailID", for: indexPath) as! SearchCocktailCollectionViewCell

        cell.searchCocktailLbl.text = cocktailCollection[indexPath.row].strDrink!.uppercased()
        
        cell.searchCocktailIMG.layer.cornerRadius = cell.searchCocktailIMG.frame.size.width/2
        cell.searchCocktailIMG.clipsToBounds = false
        cell.searchCocktailIMG.layer.shadowColor = UIColor.black.cgColor
        cell.searchCocktailIMG.layer.shadowOpacity = 0.4
        cell.searchCocktailIMG.layer.shadowOffset =  CGSize(width: 2, height: 2)
        cell.searchCocktailIMG.layer.shadowRadius = 7
        cell.searchCocktailIMG.downloaded(from: (cocktailCollection[indexPath.row].strDrinkThumb!))
        
        return cell;
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 13, bottom: 0, right: 13)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // print("\(cocktailCollection[indexPath.row].strDrink): \(cocktailCollection[indexPath.row].idDrink)")
        
        let destination = storyboard?.instantiateViewController(identifier: "CocktailDetailsViewController") as? CocktailDetailsViewController
        destination!.cocktailID = cocktailCollection[indexPath.row].idDrink
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 216)
    }
    
    func downloadCocktailsJSON(completed: @escaping () -> ())
     {

        
        let yourString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\((userQuery)!)"
        let urlNew:String = yourString.replacingOccurrences(of: " ", with: "+").trimmingCharacters(in: .whitespacesAndNewlines)
        let url = URL(string: urlNew)!
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
