//
//  AddLocationViewController.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/4/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, EntityViewControllerInterface {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var locationNameText: UITextField!

    var entity:EntityBase?
    
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
        self.entity = Location(name: locationNameText.text!)
        self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
    }

    
    

}
