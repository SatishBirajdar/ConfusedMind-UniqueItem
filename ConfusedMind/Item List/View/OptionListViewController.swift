//
//  ViewController.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2017-08-22.
//  Copyright © 2017 SBSoftwares. All rights reserved.
//

import UIKit
import CoreData

class OptionListViewController: UITableViewController, UITextFieldDelegate {
    var options : [NSManagedObject] = []
    var presenter: OptionListPresenter = OptionListPresenterImpl()
    var managedContext = ManagedContext()
    
    var alertText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if #available(iOS 11.0, *) {
//            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.automatic
            
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        tableView?.dataSource = self
        tableView?.delegate = self
        self.presenter.attachView(view: self)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        options = managedContext.fetchOptions()
    }
    
    @IBAction func editListClicked(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
        } else {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
        }
    }
    
    @IBAction func addOptionClicked(_ sender: UIBarButtonItem) {
        self.addNewOption()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 20 // Bool
    }
    
    func save(name: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "Option",
                                       in: managedContext)!

        let optionItem = NSManagedObject(entity: entity,
                                     insertInto: managedContext)

        optionItem.setValue(name, forKeyPath: "name")

//        var item: NSManagedObject
//
//        item = managedContext.entityForOptionName(optionName: name)
        
        do {
            try managedContext.save()
            options.append(optionItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension OptionListViewController: OptionListPresenterView {
    func loadOptionList(options: [Option]) {
        self.options = options
    }
    
    func addNewOption() {
        
        let alert = UIAlertController(title: "Add a new option",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            let textField = alert.textFields?.first
            guard let nameToSave = textField?.text,  textField?.text != "" else {
                print("Textfield is empty")
                return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func deleteOption(index: Int) {
        managedContext.deleteOptionFromManagedContext(index: index)
    }
    
}

extension OptionListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionItem = self.options[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OptionTableCell
        cell.optionName.text = optionItem.value(forKeyPath: "name") as? String
        cell.row = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.options.count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            options.remove(at: indexPath.row)
            managedContext.deleteOptionFromManagedContext(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
         }
    }
}

extension OptionListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: false)
//        cell.isSelected = true
    }
}

class OptionTableCell: UITableViewCell, UITextViewDelegate {
    var row: Int = 0
    @IBOutlet weak var optionName: UITextField!
    var managedContext = ManagedContext()
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 20
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        
        let newOptionName: String = self.optionName.text!
        
        let editImage = UIImage.init(named: "editItem")
        let doneImage = UIImage.init(named: "saveIcon")
        
        if (sender.imageView?.image?.isEqualToImage(image: editImage!))! {
            self.optionName.isEnabled = true
            self.optionName.becomeFirstResponder()
            sender.setImage(doneImage, for: .normal)
        } else {
            self.optionName.isEnabled = false
            self.optionName.resignFirstResponder()
            sender.setImage(editImage, for: .normal)

            self.managedContext.editOptionFromManagedContext(optionName: newOptionName, index: row)
        }
    }
//    override var isSelected: Bool
//        {
//        didSet{
//            if (isSelected)
//            {
//                print("custom row selected \(self.itemName.text)")
//            }
//            else
//            {
//                print("custom row not selected")
//            }
//        }
//    }
}
