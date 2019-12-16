//
//  HealthCalculatorViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/15/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class HealthCalculatorViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var calculator = ["Body Mass Index","Basal Metabolic Rate","Ideal Weight Calculator"]
    override func viewDidLoad()
    {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
}
extension HealthCalculatorViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return calculator.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.rowHeight = 100
        let cell = tableView.dequeueReusableCell(withIdentifier: "health") as! AllTableViewCell
        cell.healthCalculator.text = calculator[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
