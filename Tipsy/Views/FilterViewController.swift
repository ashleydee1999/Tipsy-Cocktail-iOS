import UIKit

class FilterViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    //var filterCollection = [FilterItem]()
    var filterCollection = FilterItem.all()
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        filterCollectionView.dataSource =  self
        filterCollectionView.delegate = self
        filterCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return filterCollection.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCellcocktailID", for: indexPath) as! FilterCollectionViewCell

        cell.itemLbl.text = filterCollection[indexPath.row].name.uppercased()
        
        cell.itemIMG.layer.cornerRadius = cell.itemIMG.frame.size.width/2
        cell.itemIMG.clipsToBounds = false
        cell.itemIMG.layer.shadowColor = UIColor.black.cgColor
        cell.itemIMG.layer.shadowOpacity = 0.4
        cell.itemIMG.layer.shadowOffset =  CGSize(width: 2, height: 2)
        cell.itemIMG.layer.shadowRadius = 7
        cell.itemIMG.image = UIImage(named: filterCollection[indexPath.row].img)
        
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
       // print("\(cocktailCollection[indexPath.row].strDrink): \(cocktailCollection[indexPath.row].idDrink)")
        
        let destination = storyboard?.instantiateViewController(identifier: "FilterDetailsViewController") as? FilterDetailsViewController
        destination!.fDetailsURL = filterCollection[indexPath.row].url
    destination!.chosenFilter = filterCollection[indexPath.row].name
        self.navigationController?.pushViewController(destination!, animated: true)
    }
}
