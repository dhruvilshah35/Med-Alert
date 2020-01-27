//
//  AddAppointmentViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/15/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import CoreData

var globalAppointmentName: String?

class AddAppointmentViewController: UIViewController
{
    @IBOutlet weak var addAppointment: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var appointments = [String]()
    var timer = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Appointments"
        tableView.tableFooterView = UIView()
        appointments = []
        timer = []
        tableView.delegate = self
        tableView.dataSource = self
        retrieveData()
    }
    
    @IBAction func unwindToAppointment(segue:UIStoryboardSegue) {}
    
    @IBAction func addAppointment(_ sender: Any)
    {
        globalAppointmentName = nil
        performSegue(withIdentifier: "addAppoint", sender: self)
    }
    
    func retrieveData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Appointment")
        let users = try! managedContext.fetch(fetchRequest)
        for data in users as! [NSManagedObject]
        {
            appointments.append(data.value(forKey: "aName") as! String)
            timer.append(data.value(forKey: "alarm") as! String)
        }
        if appointments.isEmpty
        {
            emptyView.isHidden = false
            tableView.isHidden = true
        } else
        {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
}
extension AddAppointmentViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointment") as! AllTableViewCell
        cell.appointmentName.text = appointments[indexPath.row]
        cell.appointmentAlarm.text = timer[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Please select from following:", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            globalAppointmentName = self.appointments[indexPath.row]
            self.performSegue(withIdentifier: "addAppoint", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            globalAppointmentName = self.appointments[indexPath.row]
            self.daleteData()
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
    
    func daleteData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Appointment")
        fetchRequest.predicate = NSPredicate(format: "aName = %@",globalAppointmentName!)
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
}
