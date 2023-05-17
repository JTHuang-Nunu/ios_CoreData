//
//  ViewController.swift
//  ios_CoreData
//
//  Created by Mac15 on 2023/5/11.
//

import UIKit
import CoreData

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var carPlate: UITextField!
    
    @IBAction func clearInfo(_ sender: UIButton) {
        clientName.text = ""
        clientId.text = ""
        carPlate.text = ""
        myImage.image = nil
    }
    @IBAction func clickreturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func selected(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        show(imagePicker, sender: myImage)
    }
    @IBAction func saveData(_ sender: UIButton) {
        if(clientId.text == "") || (clientName.text == "") || (carPlate.text == "") || (myImage.image == nil){
            MyAlertController("Error")
        }else{
            let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
            user.setValue(clientName.text, forKey: "cname")
            user.setValue(clientId.text, forKey: "cid")
            user.setValue(myImage.image?.pngData(), forKey: "plate")
            let car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
            car.setValue(carPlate.text, forKey: "plate")
            user.addToOwn(car)
            app.saveContext()
            MyAlertController("Successful alert")
        }
    }
    
    @IBAction func loadData(_ sender: Any) {
        let fetchId = NSPredicate(format: "cid BEGINSWFIT[cd]%@", clientId.text!)
        let fetchName = NSPredicate(format: "cname BEGINSWIFT[cd] %@", clientName.text!)
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        var predicate = NSCompoundPredicate()
        if (clientId.text != "") && (clientName.text == "") {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchId])
        }else if(clientId.text == "") && (clientName.text != ""){
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchName])
        }else{
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchId, fetchName])
        }
        fetchRequest.predicate = predicate
        do {
            let Users = try viewContext.fetch(fetchRequest)
            if Users == [] {
                MyAlertController("Unsuccessful load")
            }
            for user in Users {
                clientId.text = user.cid
                clientName.text = user.cname
                myImage.image = UIImage(data: user.cimage! as Data)
                for car in user.own as! Set<Car> {
                    carPlate.text = car.plate
                }
            }
        }catch {
            print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 1...6{
            if let image = UIImage(named: "0\(i).jpg"){
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        viewContext = app.persistentContainer.viewContext
        deleteAllUserData()
        print(NSPersistentContainer.defaultDirectoryURL())
        insertUserData()
        queryAllUserData()
//
//        queryWithpredicate()
        
//        storedFetch()
//        insert_onetoMany()
//        query_onetoMany()
//        saveImage()
//        loadImage()
        
    
        
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
            let cars = try viewContext.fetch(Car.fetchRequest())
            for user in allUsers as! [UserData] {
                viewContext.delete(user)
            }
            for c in cars as! [Car] {
                viewContext.delete(c)
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
    
    func storedFetch(){
        let model = app.persistentContainer.managedObjectModel
        if let fetchRequest = model.fetchRequestTemplate(forName: "FetchRequest"){
            do{
                let allUsers = try viewContext.fetch(fetchRequest)
                for user in allUsers as! [UserData] {
                    print("\((user.cid)!), \((user.cname)!)")
                    
                }
            }catch{
                print(error)
            }
        }
    }
    
    func insert_onetoMany(){
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M11015019"
        user.cname = "Nick"
        
        var car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "811-NGC"
        user.addToOwn(car)
        
        car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        
        car.plate = "PCN-0417"
        user.addToOwn(car)
        app.saveContext()
    }
    
    func query_onetoMany(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cid like 'M11015019'")
        fetchRequest.predicate = predicate
        
        
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                if user.own == nil {
                    print("\((user.cname)!),沒有車")
                }
                else {
                    print("\((user.cid)!)有,\((user.own?.count)!)部車")
                    for car in user.own as! Set<Car> {
                        print("車牌是\((car.plate)!)")
                    }
                    
                }
            }
        }catch {
            print(error)
        }
    }
    func saveImage(){
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815027"
        user.cname = "Serena"
        let image = UIImage(named: "03.jpg")
        let imageData = image?.pngData()
        user.cimage = imageData
        app.saveContext()
    }
    
    func loadImage(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cid like 'M10815027'")
        fetchRequest.predicate = predicate
        
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                myImage.image = UIImage(data: user.cimage! as Data)
            }
        }catch {
            print(error)
        }
    }
    func MyAlertController(_ result: String){
        var alert = UIAlertController()
        if result == "Error" {
            alert = UIAlertController(title: "Error", message: "Please enter comoplete information", preferredStyle: .alert)
        }else if(result == "Successful insert") {
            alert = UIAlertController(title: "Successful insert", message: String(clientName.text!) + " added finish" , preferredStyle: .alert)
        }
        let action = UIAlertAction(title: "I got it!", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}



