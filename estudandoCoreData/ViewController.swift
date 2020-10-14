//
//  ViewController.swift
//  estudandoCoreData
//
//  Created by José João Silva Nunes Alves on 13/10/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var mainView: View = {
        var table = View()
        table.tableView.delegate = self
        table.tableView.dataSource = self

        return table
    }()
    
    lazy var allData: [Movie] = [Movie]() {
        didSet {
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
//        deleteAllData()
//        for i in 0...10 {
//            self.addNewMovie(with: "Filme \(i)", randomDate: "0\(i)/0\(i)/0\(i)")
//        }

        self.loadData()
    }

    func addNewMovie(with name: String, randomDate: String) {
        let context = AppDelegate.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)!
        let date = NSEntityDescription.entity(forEntityName: "Age", in: context)!
    
        entity.relationships(forDestination: date)

        let movie = NSManagedObject(entity: entity, insertInto: context)
        let dateOb = NSManagedObject(entity: date, insertInto: context)
    
        dateOb.setValue(randomDate, forKey: "date")

        movie.setValue(name, forKey: "name")
        movie.setValue(dateOb, forKey: "date")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        
        let context = AppDelegate.viewContext
        do {
            let results = try context.fetch(fetchRequest) as! [Movie]
            for item in results {
                context.delete(item)
            }
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteItem(indexPath: IndexPath) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.fetchOffset = indexPath.row
        fetchRequest.fetchLimit = 1
        
        let context = AppDelegate.viewContext
        
        let item = allData.remove(at: indexPath.row )
        do {
            let result = try context.fetch(fetchRequest).first as! Movie
            context.delete(result)
            try context.save()
        } catch{
            self.allData.insert(item, at: indexPath.row)
        }
    }

    func loadData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.includesPendingChanges = false

        let context = AppDelegate.viewContext
        do{
            let results = try context.fetch(fetchRequest)
            self.allData = results as! [Movie]
            
        }catch{
            fatalError("Error is retriving titles items")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.configure(title: self.allData[indexPath.row].name!, date: self.allData[indexPath.row].date!.date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .right)
            self.deleteItem(indexPath: indexPath)
           
            tableView.endUpdates()
        }
    }
}
