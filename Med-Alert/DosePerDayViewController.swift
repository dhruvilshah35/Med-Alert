//
//  DosePerDayViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class DosePerDayViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var doses: [Int] = [1,2,3,4,5,6,7,8,10]
    var selectedDose: Int = 0
    
    override func viewDidLoad()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
    @objc func doneButton(sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: "unwindByDay", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let DestVC = segue.destination as! MedicineDetailViewController
        DestVC.dosePerDay = String(selectedDose)
    }
}
extension DosePerDayViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return doses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dosePerDay") as! AllTableViewCell
        cell.dosePerDay.text = String(doses[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedDose = doses[indexPath.row]
    }
}
