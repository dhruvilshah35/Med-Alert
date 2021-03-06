//
//  MyMedicineViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

var globalname: String?

class MyMedicineViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    var medName = [String]()
    var timerList = [String]()
    var isComplete: Bool?
    var status = [Bool]()
    var uniqueString = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Medicines"
        medName = []
        timerList = []
        status = []
        uniqueString = []
        tableView.delegate = self
        tableView.dataSource = self
        retrieveData()
        tableView.reloadData()
    }

    @IBAction func unwindToMainMedicine(segue:UIStoryboardSegue) {}
    
    @IBAction func addMedicineButton(_ sender: Any)
    {
        globalname = nil
        performSegue(withIdentifier: "addMed", sender: self)
    }
    
    func retrieveData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Medicine")
        let users = try! managedContext.fetch(fetchRequest)
        for data in users as! [NSManagedObject]
        {
            medName.append(data.value(forKey: "name") as! String)
            timerList.append(data.value(forKey: "timer") as! String)
            status.append(data.value(forKey: "isComplete") as! Bool)
            uniqueString.append(data.value(forKey: "identifier") as! String)
        }
        if medName == []
        {
            emptyView.isHidden = false
            tableView.isHidden = true
        }else
        {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
}
extension MyMedicineViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return medName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medList") as! AllTableViewCell
        if status[indexPath.row] == true
        {
            cell.medName.text = medName[indexPath.row]
            cell.timer.text = timerList[indexPath.row]
            cell.accessoryType = .checkmark
        } else
        {
            cell.medName.text = medName[indexPath.row]
            cell.timer.text = timerList[indexPath.row]
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Please select from following:", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            globalname = self.medName[indexPath.row]
            self.performSegue(withIdentifier: "addMed", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            globalname = self.medName[indexPath.row]
             UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.uniqueString[indexPath.row]])
            self.deleteData()
        }))
        alert.addAction(UIAlertAction(title: "Complete", style: .default, handler: {
            (action) in
            globalname = self.medName[indexPath.row]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.uniqueString[indexPath.row]])
            self.retrieveStatus()
            self.updateData()
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
    func retrieveStatus()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "name = %@", globalname!)
        let users = try! managedContext.fetch(fetchRequest)
        for data in users as! [NSManagedObject]
        {
            isComplete = data.value(forKey: "isComplete") as? Bool
        }
    }
    
    func deleteData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "name = %@",globalname!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let object = test[0] as! NSManagedObject
            managedContext.delete(object)
            do
            {
                try managedContext.save()
                viewDidLoad()
            } catch
            {
                print(error)
            }
        } catch
        {
            print(error)
        }
    }
    
    func updateData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "name = %@", globalname!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let object = test[0] as! NSManagedObject
            if isComplete == false
            {
                object.setValue(true, forKey: "isComplete")
            }
            do
            {
                try managedContext.save()
                print("successfully")
                viewDidLoad()
            } catch
            {
                print(error)
            }
        } catch
        {
            print(error)
        }
    }
}

