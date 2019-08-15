//
//  ViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/12/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    //As soon as selectedCategory gets set with a value, it will call loadItems()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    //Sets number of rows to the array count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    //Populates cells with items from the array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  //allows us to tap into the cell that gets created inside the superclass. It taps into the cell at the current indexPath
        
        if let item = todoItems?[indexPath.row] {   //if there are items
            
            cell.textLabel?.text = item.title   //title property of Item object
            
            //Ternary: cell.accessoryType is set to .checkmark if item.done is true and .none if false
            cell.accessoryType = item.done ? .checkmark : .none

        } else { //if no items
            
            cell.textLabel?.text = "No Items Added"
            
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    //Detects which row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {   //if not nil
            
            do {
                try realm.write {
                    item.done = !item.done  //writes updated done property to realm so we can check/uncheck item
                }
            } catch {
                print("Error saving done property, \(error)")
            }
            
        }
        
        tableView.reloadData()
        
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
            //What happens once the user clicks the Add Item button on UIAlert

            if let currentCategory = self.selectedCategory {    //unwraps it and checks to see if the categories are the same
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)   //adds new item to list of items for that specific category
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }

            }
            
            self.tableView.reloadData()
            
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
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //loads and sorts list of items for the selected category by taking the items' titles
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Model
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = todoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            
        }

        
    }
    
}


//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    //Gets triggered when user hits the search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true) //update todoItems to equal todoItems filtered by given predicate and sorted
    
        tableView.reloadData()
    }
    
    //Every letter you type or when you go from text to no text in the search bar, it will trigger this method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //When it goes from text to no text (when you hit the x button to clear the text)
        if searchBar.text?.count == 0 {
            loadItems() //default will fetch and show all items for that category
            
            //runs method in the main queue
            DispatchQueue.main.async {  //manager that assigns projects to different threads. Tapping into the main thread
                searchBar.resignFirstResponder()    //tells searchBar to stop being the first responder (searchBar and keyboard go away)
            }
        }
    }
    
}


