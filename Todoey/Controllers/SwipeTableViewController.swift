//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Stephanie Torres on 8/7/19.
//  Copyright © 2019 Stephanie Torres. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75.0
        
    }
    
    //TableView Datasource Methods
    
    //This is where we initialize the SwipeTableViewCell as the default cell for all the tableViews that inherit this class
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }
    
    //Copied from SwipeCellKit Documentation. Handles what happens when a user swipes a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil } //checks that the orientation of the swipe is from the right
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            //what happens when the cell gets swiped
            
            self.updateModel(at: indexPath)
            
        }
        
        //the image that appears when we swipe
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
        
    }
    
    //allows you to delete items when you swipe all the way
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive   //chosen based on documentation
        return options
    }

    //updates data model
    func updateModel(at indexPath: IndexPath) {
        
        
    }
    
}



