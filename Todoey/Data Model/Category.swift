//
//  Category.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/18/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()  //lists are a collection type similar to arrays. items holds a list of item objects. This defines the forward relationship ie inside each category, there's a list of items
    
}
