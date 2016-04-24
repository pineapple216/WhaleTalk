//
//  AllChatsViewController.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 18/04/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController {

    var context: NSManagedObjectContext?
    
    private var fetchResultsController: NSFetchedResultsController?
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "MessageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_chat.png"), style: .Plain, target: self, action: "newChat")
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        if let context = context{
            let request = NSFetchRequest(entityName: "Chat")
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController?.delegate = self
            
            do{
                try fetchResultsController?.performFetch()
            }
            catch{
                print("There was a problem fetching")
            }
        }
        fakeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newChat(){
        
    }
    
    func fakeData(){
        guard let context = context else {return}
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as? Chat
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath){
        let cell = cell as! ChatCell
        
        guard let chat = fetchResultsController?.objectAtIndexPath(indexPath) as? Chat else {return}
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        cell.nameLabel.text = "Eliot"
        cell.dateLabel.text = formatter.stringFromDate(NSDate())
        cell.messageLabel.text = "Hey!"
    }
}

extension AllChatsViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultsController?.sections else {return 0}
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
}

extension AllChatsViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let chat = fetchResultsController?.objectAtIndexPath(indexPath) as? Chat else {return}
        
        
    }
}

extension AllChatsViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            configureCell(cell!, atIndexPath: indexPath!)
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}

















