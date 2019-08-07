//
//  Item.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/18/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //defines the inverse relationship of items. Each category has a One to Many relationship and each item has an inverse relationship to a category called parentCategory. Uses the forward relationship items
    
}
