//
//  MyMedicineViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class MyMedicineViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func addMedicineButton(_ sender: Any)
    {
        performSegue(withIdentifier: "addMed", sender: self)
    }
}
