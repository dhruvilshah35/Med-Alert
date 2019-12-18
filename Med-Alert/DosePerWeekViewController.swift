//
//  DosePerWeekViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import CoreData

class DosePerWeekViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var weekdays: [String]?
    var selectedWeekday: String = ""
    var selectedcell = [Int]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Weekdays"
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        if let thirdCol = getPlist()
        {
            weekdays = thirdCol
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    @objc func doneButton(sender: UIBarButtonItem)
    {
        selectedWeekday = ""
        selectedcell.sort()
        if selectedcell.count != 0
        {
            for weekday in selectedcell
            {
                selectedWeekday = selectedWeekday + String(weekday + 1)
            }
            if let _ = globalname
            {
                updateReminder()
            }
            performSegue(withIdentifier: "unwindByWeek", sender: self)
        } else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter all the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let DestVC = segue.destination as! MedicineDetailViewController
        DestVC.weekdayString = selectedWeekday
        print(selectedWeekday)
        DestVC.viewDidLoad()
    }
    
    func updateReminder()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "name = %@", globalname!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let object = test[0] as! NSManagedObject
            object.setValue(selectedWeekday, forKey: "week")
            do
            {
                try managedContext.save()
                print("update successfully")
            } catch
            {
                print(error)
            }
        } catch
        {
            print(error)
        }
    }
    
    func getPlist() -> [String]?
    {
        if  let path = Bundle.main.path(forResource: "details", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }
        
        return nil
    }
}
extension DosePerWeekViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let weekHasValue = weekdays
        {
            return weekHasValue.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekdays") as! AllTableViewCell
        if let weekdayHasValue = weekdays
        {
            cell.weekdays.text = weekdayHasValue[indexPath.row]
        }
        tableView.rowHeight = 80
        cell.accessoryType = selectedcell.contains(indexPath.row) ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedcell.contains(indexPath.row)
        {
            let myIndex = selectedcell.firstIndex(of: indexPath.row)
            selectedcell.remove(at: myIndex!)
        }
        else
        {
            selectedcell.append(indexPath.row)
        }
        tableView.reloadData()
    }
}
