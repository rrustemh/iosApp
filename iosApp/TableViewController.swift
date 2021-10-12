//
//  TableViewController.swift
//  iosApp
//
//  Created by Rrustem on 10/10/21.
//  Copyright © 2021 GrFL. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func deleteRow(index:IndexPath)->Void {
        print("indexi osht \(index.row)")
        let note=noteList[index.row]
        note.deleteFromDb();
        print("delete tbl")
        noteList.remove(at: index.row)
        tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
        
    }
    func editRow(index:IndexPath,text:String,date:String?)-> Void {
        let note=noteList[index.row]
        note.note=text
        if date != nil {
            note.date=date
        }
        noteList[index.row]=note
        tableView.reloadRows(at: [index], with: .top)
        note.editRow()
    }

}
extension TableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var date:String?=nil
        var text:String?=nil
        let edit=UIContextualAction(style: .normal, title: "Edit") { (action, view,nil) in
            let editalertContorller=UIAlertController(title: "Edit note", message: "Edit note message or date", preferredStyle: .alert)
            editalertContorller.addTextField(configurationHandler: {(textfield)-> Void in
                textfield.text=noteList[indexPath.row].note
            })
            
            let cancelAction=UIAlertAction(title: "Cancel", style:.cancel, handler: {actioni->Void in
                editalertContorller.dismiss(animated: true, completion: nil)
            })
            let okAction=UIAlertAction(title:"Ok",style:.destructive,handler:{action->Void in
                text=editalertContorller.textFields![0].text!
                self.editRow(index:indexPath,text:text!,date:date)
            })
            let displayDateAction=UIAlertAction(title:"Edit the date",style:.destructive,handler:{action->Void in
                text=editalertContorller.textFields![0].text!
                let datealertcontrolerr=UIAlertController(title: "Change date", message: "Click on datepicker to change the date", preferredStyle: .actionSheet)
            
                let datepicker=UIDatePicker(frame: CGRect(x: -40, y: 50, width: datealertcontrolerr.view.frame.width, height: 100))
                datepicker.timeZone=NSTimeZone.local
             
                let doneAction=UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (action) in
                    date=datepicker.date.description(with:Locale(identifier: "en_US"))
                    self.editRow(index: indexPath, text: text!, date: date)
                    datealertcontrolerr.dismiss(animated: true, completion: nil)
                    
                })
                let height=NSLayoutConstraint(item: datealertcontrolerr.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 400)
                datealertcontrolerr.view.addConstraint(height)
                datealertcontrolerr.view.addSubview(datepicker)
                datealertcontrolerr.addAction(doneAction)
                self.present(datealertcontrolerr, animated: true, completion: nil)
            })
            editalertContorller.addAction(cancelAction)
            editalertContorller.addAction(okAction)
            editalertContorller.addAction(displayDateAction	)
            self.present(editalertContorller,animated:true,completion:nil)
        }
    
        edit.backgroundColor=#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        
        return UISwipeActionsConfiguration(actions:[edit])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete=UIContextualAction(style: .destructive, title: "Delete") { (action,view,nil) in
            let alert=UIAlertController(title: "Delete", message: "Are you sure for deleting note", preferredStyle:.alert)
            
            let cancelAction=UIAlertAction(title: "Cancel", style:.cancel, handler: {actioni->Void in
                alert.dismiss(animated: true, completion: nil)
            })
            let okAction=UIAlertAction(title:"Ok",style:.destructive,handler:{action->Void in
                    self.deleteRow(index:indexPath)
            })
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        delete.backgroundColor=#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return UISwipeActionsConfiguration(actions:[delete])
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let note = noteList[indexPath.row]
        
        cell.textLabel?.text=note.note
        cell.detailTextLabel?.text=note.date
        
        return cell
    }
    
}

