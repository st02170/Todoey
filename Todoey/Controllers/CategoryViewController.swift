//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/16/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none

    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //If not nil, return categories.count. If nil, return 1 cell which will say "No Categories Added"
        
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  //allows us to tap into the cell that gets created inside the superclass. It taps into the cell at the current indexPath
    
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"  //name property of category object if not nil. If nil, return text specified
    
        cell.backgroundColor = UIColor.randomFlat
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    //Prep work to make sure that it takes user to the correct to do list for the selected category and not show all the items that were ever saved. Triggered just before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Grabs reference to where segue takes you (destination)
        let destinationVC = segue.destination as! TodoListViewController
        
        //Tells index of the current selected row. Optional value so use if statement
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()

    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)    //pulls out all the items in Realm that are Category objects

        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            
        }
        
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   //local variable for alertTextField
        
        //Creates the alert that pops up when the add button is pressed
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //Button user clicks to add a category
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What happens once the user clicks the Add Category button on our UIAlert
            
            //Sets newCategory equal to what the user writes in the textfield
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        //Adds a textfield to the alert so user can add their category
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        //Adds the action to the alert that pops up
        alert.addAction(action)
        
        //Shows/presents the alert
        present(alert, animated: true, completion: nil)

    }
    
}

