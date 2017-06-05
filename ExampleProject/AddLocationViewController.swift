//
//  AddLocationViewController.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/4/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "Add Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler(sender:)))
        saveButton.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)

    }
    
    func cancelHandler(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }

    func saveHandler(sender: UIBarButtonItem) {
        print("Save clicked!")
        self.dismiss(animated: true, completion: nil)
    }

    
    

}
