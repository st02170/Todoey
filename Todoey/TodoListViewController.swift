//
//  ViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/12/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //As soon as selectedCategory gets set with a value, it will call loadItems()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //When our app is running live, then UIApplication.shared will correspond to our live application object. delegate is the delegate of the App object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    //Sets number of rows to the array count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    //Populates cells with items from the array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title   //title property of Item object
        
        let item = itemArray[indexPath.row]
        
        //Ternary: cell.accessoryType is set to .checkmark if item.done is true and .none if false
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    //Detects which row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //context.delete(itemArray[indexPath.row]) = removes data (current row) from the context/Core Data
        //itemArray.remove(at: indexPath.row) = removes current row and updates itemArray, which is used to populate the tableview
        
        //Sets the done property of the item to the opposite of what it currently is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems() //allows the properties to be updated in the encoded plist when checked off
        
        tableView.deselectRow(at: indexPath, animated: true)    //Keeps the cell from turning gray when clicked. Only flashes gray briefly, since it goes back to being deselected
        
    }
    
    
    //MARK: - Add New Items
    
    //Method for when the add button is pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   //local variable for alertTextField
        
        //Creates the alert that pops up when the add button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //Button user clicks to add an item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens once the user clicks the Add Item button on our UIAlert
            
            //Sets newItem equal to what the user writes in the textfield
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory //parentCategory from DataModel
            
            //Adds item to the array
            self.itemArray.append(newItem)
            
            self.saveItems()    //encodes and writes our data to the encoded plist

        }
        
        //Adds a textfield to the alert so user can add their item
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //Adds the action to the alert that pops up
        alert.addAction(action)
        
        //Shows/presents the alert
        present(alert, animated: true, completion: nil)

    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
       
        do{
            try context.save()  //transfers what's in context to our permanent data storage
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)  //filters and keeps only the items where the parentCategory matches the selectedCategory
        
        //Checks if predicate is nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])    //if not nil, query results using the predicate while filtering by category
        } else {
            request.predicate = categoryPredicate   //if nil, just filter by category since no query is being requested
        }
        
        do {
            itemArray = try context.fetch(request) //fetches current request. Default request is a blank request that fetches everything inside our persistent container and saves it inside itemArray, which is what we use to load our tableview
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
}


//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    //Gets triggered when user hits the search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest() //our request, which will return an array of items
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //Structures the query. Checks if the title of the items contain what is in the search bar. searchBar.text is in place of %@
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]    //sorts the results in alphabetical order
        
        loadItems(with: request, predicate: predicate)

    }
    
    //Every letter you type or when you go from text to no text in the search bar, it will trigger this method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //When it goes from text to no text (when you hit the x button to clear the text)
        if searchBar.text?.count == 0 {
            loadItems() //default will fetch and show all items in the persistent store
            
            //runs method in the main queue
            DispatchQueue.main.async {  //manager that assigns projects to different threads. Tapping into the main thread
                searchBar.resignFirstResponder()    //tells searchBar to stop being the first responder (searchBar and keyboard go away)
            }
        }
    }
    
}


