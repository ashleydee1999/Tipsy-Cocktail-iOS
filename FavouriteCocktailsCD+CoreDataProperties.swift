//
//  FavouriteCocktailsCD+CoreDataProperties.swift
//  FavouriteCocktailsCD
//
//  Created by Ashley Dube on 2021/08/09.
//
//

import Foundation
import CoreData


extension FavouriteCocktailsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCocktailsCD> {
        return NSFetchRequest<FavouriteCocktailsCD>(entityName: "FavouriteCocktailsCD")
    }

    @NSManaged public var idFavDrink: String?

}

extension FavouriteCocktailsCD : Identifiable {

}
