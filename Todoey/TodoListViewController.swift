//
//  ViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 7/12/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
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
    
    //Detects which row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //Sets the done property of the item to the opposite of what it currently is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems() //allows the properties to be updated in the encoded plist when checked off
        
        //Forces the tableview to call its data source methods to reload data
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)    //Keeps the cell from turning gray when clicked. Only flashes gray briefly, since it goes back to being deselected
        
    }
    
    //Method for when the add button is pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   //local variable for alertTextField
        
        //Creates the alert that pops up when the add button is pressed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //Button user clicks to add an item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens once the user clicks the Add Item button on our UIAlert
            
            //Sets newItem equal to what the user writes in the textfield
            let newItem = Item()
            newItem.title = textField.text!
            
            //Adds item to the array
            self.itemArray.append(newItem)
            
            self.saveItems()    //encodes and writes our data to the encoded plist
            
            //Reloads cells with new data so it is visible to the user
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
    
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)   //encodes data
            try data.write(to: dataFilePath!)    //writes data to our data file path
        } catch {
            print("Error encoding item array, \(error)")    //prints error
        }
        
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {  //allows us to tap into our data. Constant data is set equal to data created using the contents of our dataFilePath. try? turns the result of this method into an optional
            
            let decoder = PropertyListDecoder() //will decode our items
            
            do {
                itemArray = try decoder.decode([Item].self, from: data) //itemArray is equal to decoded data
            } catch {
                print("Error decoding itemArray, \(error)")
            }
            
        }
    }
    
}


