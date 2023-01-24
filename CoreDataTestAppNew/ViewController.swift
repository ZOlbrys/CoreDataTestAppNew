//
//  ViewController.swift
//  CoreDataTestAppNew
//
//  Created by Zach Olbrys on 2/6/19.
//  Copyright © 2019 ZOlbrys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var coreDataController: CoreDataController?
    
    private struct Constants {
        static let itemCount = 10000
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataController = CoreDataController()
    }
    
    @IBAction func crash() {
        coreDataController?.insertItems(count: Constants.itemCount)
        coreDataController?.fetch()
    }
}
