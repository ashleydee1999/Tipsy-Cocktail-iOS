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
    var fDetailsCollection = [FilterCategoriesDetailsProperties]()
    var fDetailsURL: String?
    var chosenFilter: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        switch (chosenFilter!)
        {
            case "Categories":
                downloadCategoriesDetaillsJSON {
                    self.fDetailsTableView.reloadData()
                }
                
            case "Glasses":
                downloadGlassesDetaillsJSON {
                    self.fDetailsTableView.reloadData()
                }
        
            case "Ingredients":
                downloadIngredientsDetaillsJSON {
                    self.fDetailsTableView.reloadData()
                }
        
            case "Alcoholic":
                downloadAlcoholicDetaillsJSON {
                    self.fDetailsTableView.reloadData()
                }
            
        
            default:
                print("No Options Selected")
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
        
        cell.filterDetailsIMG.image = UIImage(named: "\(fDetailsCollection[indexPath.row].strCategory)IMG")
        cell.filterDetailsLbl?.text = fDetailsCollection[indexPath.row].strCategory
        
        return cell
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
            self.fDetailsCollection = try jsonDecoder.decode(FilterCategoriesDetailsCocktails.self, from: unwrappedData).drinks
                DispatchQueue.main.async
                {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    
    }
    
    func downloadGlassesDetaillsJSON(completed: @escaping () -> ())
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
            self.fDetailsCollection = try jsonDecoder.decode(FilterCategoriesDetailsCocktails.self, from: unwrappedData).drinks
                DispatchQueue.main.async
                {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    
    }
    
    func downloadIngredientsDetaillsJSON(completed: @escaping () -> ())
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
            self.fDetailsCollection = try jsonDecoder.decode(FilterCategoriesDetailsCocktails.self, from: unwrappedData).drinks
                DispatchQueue.main.async
                {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    
    }
    
    func downloadAlcoholicDetaillsJSON(completed: @escaping () -> ())
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
            self.fDetailsCollection = try jsonDecoder.decode(FilterCategoriesDetailsCocktails.self, from: unwrappedData).drinks
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
