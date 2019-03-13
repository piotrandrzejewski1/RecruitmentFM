//
//  ViewController.swift
//  RecruitmentFM
//
//  Created by Piotr Andrzejewski on 11/03/2019.
//  Copyright © 2019 Piotr Andrzejewski. All rights reserved.
//
import UIKit
import CoreData
import ProgressHUD
import Alamofire
import SwiftyJSON

class ListViewController: UITableViewController {

    var items : Array<Item> = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var ads : Item? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        do {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
            let data = try context.fetch(request)
            if data.count == 0 {
                ProgressHUD.show()
                requestForData {
                    ProgressHUD.dismiss()
                }
            }
            else {
                items = data
            }
        }
        catch {
            ProgressHUD.showError("error reading data \(error)")
        }
    }

    //MARK: tableView methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.labelTitle.text = items[indexPath.row].title
        cell.labelDescription.text = items[indexPath.row].desc?.trimUrl
        cell.labelUrl.text = items[indexPath.row].imageUrl
    
        if let date = items[indexPath.row].modificationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.labelDate.text = dateFormatter.string(from: date)
        }
        
        if let urlString = items[indexPath.row].imageUrl {
            let url = URL(string: urlString)
            
            Alamofire.request(url!).response { response in
                if let data = response.data {
                    let image = UIImage(data: data)
                    cell.imageViewItem.image = image
                } else {
                    print("Data is nil. I don't know what to do :(")
                }
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    
    //MARK: segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem" {
            let detailsVc = segue.destination as! DetailsViewController
            detailsVc.selectedItem = items[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    
    //MARK: requesting data
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        ProgressHUD.show()
        requestForData {
            ProgressHUD.dismiss()
        }
    }
    
    func requestForData(completion: (()->())? = nil) {
        Alamofire.request("https://www.futuremind.com/recruitment-task", method: .get).responseJSON { response in
        
            if let completionAction = completion {
                completionAction()
            }
            
            guard response.result.isSuccess else {
                ProgressHUD.showError("error getting data drom server \(String(describing: response.error))")
                return
            }
            
            let json : JSON = JSON(response.result.value!)

            for item in self.items {
                self.context.delete(item)
            }
            self.items.removeAll()
            
            self.items = json.array?.compactMap({ itemJson in
                let item = Item(context: self.context)
                item.desc = itemJson["description"].string
                item.imageUrl = itemJson["image_url"].string
                item.orderId = Int32(itemJson["orderId"].int!)
                item.title = itemJson["title"].string
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                item.modificationDate = dateFormatter.date(from: itemJson["modificationDate"].string!)
                return item
            }).sorted(by: { (a, b) -> Bool in
                return a.orderId < b.orderId
            }) ?? []
            
            do {
                try self.context.save()
            } catch {
                ProgressHUD.showError("error saving data \(String(describing: error))")
            }

            self.tableView.reloadData()
        }
    }
}

