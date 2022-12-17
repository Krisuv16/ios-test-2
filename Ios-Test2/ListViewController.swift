
/*
 File Name: AppDelegate
 Author: Krisuv Bohara(301274636)
 Date: 2022-12-13.
 Description: ListViewController
 Version: 1.0
 */
import Foundation
import UIKit

class ListScreenViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var bmiTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataList = [BmiEntity]()


    override func viewDidLoad() {
        super.viewDidLoad()
        bmiTableView.dataSource = self
        bmiTableView.delegate = self
        bmiTableView.separatorInset = bmiTableView.layoutMargins
        title = "BMI History"
        fetchNotes()
    }
    
    func fetchNotes(){
        //Fetching data from CoreData and isplaying in the Table View
        do{
            self.dataList =  try context.fetch(BmiEntity.fetchRequest())
//            DispatchQueue.main.async {
                self.bmiTableView.reloadData()
//            }
        }catch{
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = bmiTableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CellTableViewCell
        
        let thisNote: BmiEntity!
        thisNote = dataList[indexPath.row]
        
        cells.dateLabel.text = "Date: " + thisNote.date!
        cells.timeLabel.text = "Time: " + thisNote.time!
        cells.bmiLabel.text = "BMI: " + thisNote.bmi!
        cells.weightLabel.text = "Weight: " + thisNote.weight!
        cells.nameLabel.text = "Name: " + thisNote.name!
        cells.unitLabel.text = "Unit: " + thisNote.unit!
        return cells
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisNote: BmiEntity!
        thisNote = self.dataList[indexPath.row]
        performSegue(withIdentifier: "onPressedDetail", sender: thisNote)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailViewController = segue.destination as? DetailViewController {
            if let data = sender as? BmiEntity {
                detailViewController.dataList = data
            }
        }
        //passing data to another view
    }
    
    
    
    //swiping right to left to delete the items in the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let thisNote: BmiEntity!
            thisNote = self.dataList[indexPath.row]
            self.context.delete(thisNote)
            
            do{
                try self.context.save()
            }
            catch{
                print("Error")
            }
            self.dataList.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    //function that adds swipe action on the leading side left side
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            //for edit
            let editAction = UIContextualAction(style: .normal, title: "Edit") {
                (action, sourceView, completionHandler) in
                let thisNote: BmiEntity!
                thisNote = self.dataList[indexPath.row]
                self.performSegue(withIdentifier: "onPressedDetail", sender: thisNote)
            }
            editAction.backgroundColor = UIColor.blue
            return UISwipeActionsConfiguration(actions: [editAction])
        }
    
}
