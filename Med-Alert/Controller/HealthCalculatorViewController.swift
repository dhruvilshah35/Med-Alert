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
    var selected = IndexPath()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Health Calculators"
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
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
        tableView.rowHeight = 80
        let cell = tableView.dequeueReusableCell(withIdentifier: "health") as! AllTableViewCell
        cell.healthCalculator.text = calculator[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        selected = indexPath
        if indexPath.row == 0
        {
            performSegue(withIdentifier: "calc", sender: self)
        }else if indexPath.row == 2
        {
            performSegue(withIdentifier: "calc", sender: self)
        }else if indexPath.row == 1
        {
            performSegue(withIdentifier: "bmr", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "calc"
        {
            let DestVC = segue.destination as! BMIViewController
            DestVC.calc = calculator[selected.row]
        }
    }
    
}
