//
//  CocktailDetails.swift
//  Tipsy
//
//  Created by IACD-Air-11 on 2021/07/18.
// Hie there

import Foundation
import UIKit

//This is for the home page
struct Cocktails: Decodable
{
    let drinks: [CocktailsProperties]
}

struct CocktailsProperties: Decodable
{
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}

//End

//Used when Searching by ID
struct SearchCocktails: Decodable
{
    let drinks: [SearchCocktailsProperties]
}

struct SearchCocktailsProperties: Decodable
{
    let strDrink: String
    let strCategory: String
    let strAlcoholic: String
    let strGlass: String
    let strInstructions: String
    let strDrinkThumb: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    
}
//End

extension UIImageView
{
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit)
    {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

