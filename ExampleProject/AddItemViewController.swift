//
//  AddItemViewController.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/4/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, EntityViewControllerInterface, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {


    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var addBinButton: UIButton!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var itemNameText: UITextField!
    @IBOutlet weak var itemQtyText: UITextField!
    @IBOutlet weak var binText: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var entity:EntityBase?
    var pickerData = [String]()
    var pickerRowSelectedHandler: ((Int) -> Void)?
    var locationArray:[String] =  ["Closet","Basement","Storage"]
    var binArray:[String] = ["Top Shelf","Bottom Drawer","Last Cabinet"]
    
    enum EntityType {
        case Bin
        case Item
        case Location
    }
    
    enum ActionType {
        case Create
        case Update
        case Delete
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchHandler(sender:)))
        self.updateTitle(actionType: ActionType.Create)
        self.entity = Item(name: "")
        addLocationButton.addTarget(self, action: #selector(addLocationHandler), for: .touchUpInside)
        addBinButton.addTarget(self, action: #selector(addBinHandler), for: .touchUpInside)
        itemNameText.delegate = self;
        itemQtyText.delegate = self;
        locationText.delegate = self;
        binText.delegate = self;
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
    }
    
    func updateTitle(actionType:ActionType) {
        navigationBar.topItem?.title = "\(String(describing:actionType)) Item"
    }
    
    // MARK: UI Delegates   {
    
    func searchHandler(sender: UIBarButtonItem) {
        print("Search clicked!")
        self.performSegue(withIdentifier: "itemSearchSegue", sender:self )
    }
    
    func addLocationHandler(sender: UIBarButtonItem) {
        print("Add location clicked!")
        self.showEditNamePopup(entityType: .Location, actionType: .Create)
//        self.performSegue(withIdentifier: "addLocationSegue", sender:self )
    }
    
    func addBinHandler(sender: UIBarButtonItem) {
        print("Add location clicked!")
        self.showEditNamePopup(entityType: .Bin, actionType: .Create)
    }

    func showEditNamePopup(entityType:EntityType, actionType:ActionType)    {
        let alert = UIAlertController(title: "\(actionType) \(entityType)", message: "Enter \(entityType) name", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "\(entityType) name"}
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
            if entityType == EntityType.Bin {
                self.binArray.append(textField.text!)
                self.binText.text = textField.text
            } else if entityType == EntityType.Location {
                self.locationArray.append(textField.text!)
                self.locationText.text = textField.text
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Picker View Data Sources and Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var allowEditing = true
        switch textField {
            case self.locationText:
                self.pickerData = locationArray
                picker.reloadAllComponents()
                self.picker.isHidden = false
                if self.locationText.text != nil && !self.locationText.text!.isEmpty  {
                    self.picker.selectRow(pickerData.index(of: self.locationText.text!)!, inComponent:0, animated: false)
                }
                else {
                    self.picker.selectRow(0, inComponent:0, animated: false)
                }
                allowEditing = false
            case self.binText:
                self.pickerData = binArray
                picker.reloadAllComponents()
                self.picker.isHidden = false
                if self.binText.text != nil && !self.binText.text!.isEmpty  {
                    self.picker.selectRow(pickerData.index(of: self.binText.text!)!, inComponent:0, animated: false)
                }
                else {
                    self.picker.selectRow(0, inComponent:0, animated: false)
                }
                allowEditing = false
            default: self.picker.isHidden = true
        }

        self.pickerRowSelectedHandler = {(selectedIndex:Int) -> Void in
            var entityType: EntityType?
            switch textField {
                case self.locationText:
                    entityType = EntityType.Location
                    self.locationText.text = self.pickerData[selectedIndex]
                case self.binText:
                    entityType = EntityType.Bin
                    self.binText.text = self.pickerData[selectedIndex]
                default: break
            }
            print("\(entityType) selected: \(selectedIndex)")
        }

        return allowEditing;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRowSelectedHandler!(row)
        self.picker.isHidden = true
    }
    
    // MARK: - Navigation   {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSearchSegue" {
//            let viewController:ItemSearchTableViewController = segue.destination as! ItemSearchTableViewController
            picker.isHidden = true
        }
    }
    
    @IBAction func unwindFromAddLocation(sender: UIStoryboardSegue) {
        let viewController = sender.source as! EntityViewControllerInterface
        if let entity = viewController.entity {
            print("Location added: \(entity.name!)")
        }
    }
    
    @IBAction func unwindToAddItem(sender: UIStoryboardSegue) {
        let itemSearchTableViewController = sender.source as! EntityViewControllerInterface
        let entity:EntityBase? = itemSearchTableViewController.entity
        if let item = entity as? Item? {
            self.entity = item
            self.updateFields(fromItem: item!)
        } else if let bin = entity as? Bin? {
            self.updateFields(fromBin: bin!)
        }
        else if let location = entity as? Location? {
            self.updateFields(fromLocation: location!)
        }
    }
    
    func updateFields(fromItem:Item)    {
        self.itemNameText.text = fromItem.name
        if let qty = fromItem.qty   {
            self.itemQtyText.text = String(qty)
        }
        self.locationText.text = fromItem.bin?.location?.name
        self.binText.text = fromItem.bin?.name
        self.updateTitle(actionType: ActionType.Update)
    }
    
    func updateFields(fromBin:Bin)    {
        self.locationText.text = fromBin.location?.name
        self.binText.text = fromBin.name
    }
    
    func updateFields(fromLocation:Location)    {
        self.locationText.text = fromLocation.name
    }

}
