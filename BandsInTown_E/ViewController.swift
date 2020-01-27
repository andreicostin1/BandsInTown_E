//
//  ViewController.swift
//  BandsInTown_E
//
//  Created by Andrei Costin on 1/6/20.
//  Copyright © 2020 Andrei Costin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            firstView.alpha = 1;
            secondView.alpha = 0;
        } else {
            firstView.alpha = 0;
            secondView.alpha = 1;
        }
    }
    
    
}

