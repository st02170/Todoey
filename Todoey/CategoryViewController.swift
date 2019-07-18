//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/16/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name   //name property of category object
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        
        do{
            try context.save()  //transfers what's in context to our permanent data storage
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()

    }
    
    func loadCategory() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request) //fetches current request. Default request is a blank request that fetches everything inside our persistent container and saves it inside categoryArray, which is what we use to load our tableview
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            //Adds category to the array
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
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
