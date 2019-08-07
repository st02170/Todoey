//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/16/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1 //If not nil, return categoryArray.count. If nil, return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"  //name property of category object
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    //Prep work to make sure that it takes us to the correct to do list for the selected category and not show us all the items that were ever saved. Triggered just before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Grabs reference to where segue takes you (destination)
        let destinationVC = segue.destination as! TodoListViewController
        
        //Tells index of the current selected row. Optional value so use if statement
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
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
        
        categoryArray = realm.objects(Category.self)    //pulls out all the items in Realm that are Category objects

        tableView.reloadData()
        
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
