

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    var cocktailCollection = [CocktailsProperties]()
    @IBOutlet weak var cocktailCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        downloadCocktailsJSON
        {
            print("All cocktails downloaded")
            self.cocktailCollectionView.reloadData()
            //print(self.cocktailCollection)
        }
        cocktailCollectionView.dataSource =  self
        cocktailCollectionView.delegate = self
        cocktailCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    //Cell configurations
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cocktailCollection.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = cocktailCollectionView.dequeueReusableCell(withReuseIdentifier: "cocktailID", for: indexPath) as! CocktailCollectionViewCell

        cell.cocktailLbl.text = cocktailCollection[indexPath.row].strDrink!.uppercased()
        
        cell.cocktailIMG.layer.cornerRadius = cell.cocktailIMG.frame.size.width/2
        cell.cocktailIMG.clipsToBounds = false
        cell.cocktailIMG.layer.shadowColor = UIColor.black.cgColor
        cell.cocktailIMG.layer.shadowOpacity = 0.4
        cell.cocktailIMG.layer.shadowOffset =  CGSize(width: 2, height: 2)
        cell.cocktailIMG.layer.shadowRadius = 7
        cell.cocktailIMG.downloaded(from: (cocktailCollection[indexPath.row].strDrinkThumb!))
        
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
        
        let destination = storyboard?.instantiateViewController(identifier: "CocktailDetailsViewController") as? CocktailDetailsVC
        destination!.cocktailID = cocktailCollection[indexPath.row].idDrink
        self.navigationController?.pushViewController(destination!, animated: true)
    }
  
    func downloadCocktailsJSON(completed: @escaping () -> ())
     {

         let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass")!
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

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView
{
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit)
    {
        if let img = imageCache.object(forKey: url.absoluteString as NSString)
        {
            self.image = img
        }
        else
        {
            contentMode = mode
            URLSession.shared.dataTask(with: url)
            { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }.resume()
        }
        
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
