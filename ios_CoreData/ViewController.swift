//
//  ViewController.swift
//  ios_CoreData
//
//  Created by Mac15 on 2023/5/11.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
        deleteAllUserData()
        print(NSPersistentContainer.defaultDirectoryURL())
        insertUserData()
//        queryAllUserData()
        
        queryWithpredicate()
    }
    func insertUserData(){
        var user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "B10815027"
        user.cname = "Nick"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "B10815028"
        user.cname = "Joe"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "B10815029"
        user.cname = "hi"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "B10815030"
        user.cname = "Zac"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "B10815031"
        user.cname = "Jimmy"
        
        app.saveContext()
    }
    func queryAllUserData(){
        do {
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData] {
                print("\((user.cid)!), \((user.cname)!)")
            }
        } catch{
            print(error)
        }
    }
    func deleteAllUserData(){
        do {
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData] {
                viewContext.delete(user)
            }
            app.saveContext()
            print("Successful delete")
        } catch{
            print(error)
        }
    }
    
    func queryWithpredicate(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cname like 'J*'")
        fetchRequest.predicate = predicate
        let sort = NSSortDescriptor(key: "cid", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                print("\((user.cid)!), \((user.cname)!)")
            }
        }catch{
            print(error)
        }
    }
}

