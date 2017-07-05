//
//  AddItemViewController.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/4/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, EntityViewControllerInterface, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

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
    let coreDataFetch = CoreDataFetch()
    
    enum ActionType {
        case Create
        case Update
        case Delete
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchHandler(sender:)))
        self.updateTitle(actionType: ActionType.Create)
        addLocationButton.addTarget(self, action: #selector(addLocationHandler), for: .touchUpInside)
        addBinButton.addTarget(self, action: #selector(addBinHandler), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)
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
        self.picker.isHidden = true
        self.showAddEntityAlertView(entityType: .Location, actionType: .Create)
    }
    
    func addBinHandler(sender: UIBarButtonItem) {
        print("Add location clicked!")
        self.picker.isHidden = true
        self.showAddEntityAlertView(entityType: .Bin, actionType: .Create)
    }
    
    func saveHandler(sender: UIBarButtonItem) {
        print("Save button clicked!")
        self.picker.isHidden = true
        let coreDataLoad = CoreDataLoad()
        let context = coreDataLoad.context
        let item = Item(context: context)
        item.name = itemNameText.text!
        item.entityType = EntityType.Item
        if let qty = Int(itemQtyText.text!) {
            item.qty = Int16(NSNumber(value:qty))
        }
        do {
            try item.validateForInsert()
        } catch{
            print("error: \(error.localizedDescription)")
        }
        coreDataLoad.saveContext()
        itemNameText.text = ""
        itemQtyText.text = ""
    }

    func showAddEntityAlertView(entityType:EntityType, actionType:ActionType)    {
        let alert = UIAlertController(title: "\(actionType) \(entityType)", message: "Enter \(entityType) name", preferredStyle: .alert)
        alert.addTextField {
            (textField) in
                textField.placeholder = "\(entityType) name"
                textField.accessibilityLabel = "\(entityType) Name Input"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            [weak alert, weak self] (_) in
                let coreDataLoad = CoreDataLoad()
                let context = coreDataLoad.context
                context.reset()
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                print("Text field: \(textField.text)")
                var isError = false
                var errorMessage = ""
                if entityType == EntityType.Bin {
                    let bin = Bin(context: context)
                    bin.name = textField.text!
                    bin.entityType = EntityType.Bin
                    let location = self!.coreDataFetch.fetchEntity(byName:self!.locationText.text!)
                    bin.binToLocationFK = location as! Location?
                    do {
                        try bin.validateForInsert()
                    } catch {
                        isError = true
                        errorMessage = error.localizedDescription
                    }
                    self!.binText.text = bin.name
                } else if entityType == EntityType.Location {
                    let location = Location(context: context)
                    location.name = textField.text!
                    location.entityType = EntityType.Location
                    self!.locationText.text = location.name
                }
            
                if !isError {
                    coreDataLoad.saveContext()
                } else {
                    UIAlertController(title: "\(actionType) \(entityType)", message: errorMessage, preferredStyle: .alert)
                }

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Picker View Data Sources and Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var allowEditing = true
        switch textField {
            case self.locationText:
                let locationArray:[Location]? = coreDataFetch.fetchEntities()
                self.pickerData = (locationArray?.map {
                        (value: Location) -> String in
                            return value.name!
                    })!
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
                let binArray:[Bin]? = coreDataFetch.fetchEntities()
                self.pickerData = (binArray?.map {
                        (value: Bin) -> String in
                        return value.name!
                })!
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
    
    @IBAction func unwindFromSearch(sender: UIStoryboardSegue) {
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
        self.itemQtyText.text = String(fromItem.qty)
        self.locationText.text = fromItem.itemToBinFK?.binToLocationFK?.name
        self.binText.text = fromItem.itemToBinFK?.name
        self.updateTitle(actionType: ActionType.Update)
    }
    
    func updateFields(fromBin:Bin)    {
//        self.locationText.text = fromBin.location?.name
//        self.binText.text = fromBin.name
    }
    
    func updateFields(fromLocation:Location)    {
        self.locationText.text = fromLocation.name
    }

}
