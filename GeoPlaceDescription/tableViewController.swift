/*
 * Copyright 2017 Himani Shah,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * instuctor and the University with the right to build and evaluate the software package for the purpose of determining your grade and program assessment
 *
 * Purpose: To add, delete and update placedescription objects from JSON Rpc server
 *
 * Ser423 Mobile Applications
 * @author Himani Shah Himani.shah@asu.edu
 *         Software Engineering, CIDSE, ASU Poly
 * @version April 2017
 */

import UIKit

class tableViewController: UITableViewController{
    let placeDescriptionLibraryObject = PlaceDescriptionLibrary()
    var places:[String:PlaceDescription] = [String:PlaceDescription]()
    var names:[String] = [String]()
    var urlString:String = ""
    var aPlace:PlaceDescription = PlaceDescription()
    
    override func viewDidLoad() {
        if let infoPlist = Bundle.main.infoDictionary {
            self.urlString = ((infoPlist["ServerURLString"]) as?  String!)!
            NSLog("The default urlString from info.plist is \(self.urlString)")
        }else{
            NSLog("error getting urlString from info.plist")
        }
        super.viewDidLoad()
        NSLog("view did load" )
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //self.names = placeDescriptionLibraryObject.getPlaceTitles()
        
        self.title = "Places List"
        self.PlaceNames()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func PlaceNames() {
        let aConnect:PlaceDescriptionLibrary = PlaceDescriptionLibrary()
        let resultNames:Bool = aConnect.getNames(callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        
                        self.names = (dict!["result"] as? [String])!
                        self.tableView.reloadData()
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })  // end of method call to getNames
    }
    func remove(_ name: String, index: IndexPath ) {
        let aConnect:PlaceDescriptionLibrary = PlaceDescriptionLibrary()
        let resultNames:Bool = aConnect.removePlace(name: name, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        self.names.remove(at: index.row)
                        self.tableView.deleteRows(at: [index], with: .fade)
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })  // end of method call to getNames
    }
    func add(_ jsonObject: NSMutableDictionary, pname: String ) {
        let aConnect:PlaceDescriptionLibrary = PlaceDescriptionLibrary()
        let resultNames:Bool = aConnect.addPlace(jsonObject: jsonObject, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        
                        self.names.append(pname)
                        self.tableView.reloadData()
                        //self.tableView.deleteRows(at: [index], with: .fade)
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })  // end of method call to getNames
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing row at: \(indexPath.row)")
        if editingStyle == .delete {
            let selectedPlace:String = names[indexPath.row]
            print("deleting the place \(selectedPlace)")
            self.remove(selectedPlace, index: indexPath)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            // don't need to reload data, using delete to make update
        }
    }
    // MARK: - Table view data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get and configure the cell...
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = names[indexPath.row]
        
        return cell
    }
    @IBAction func unwindToPlaceList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? addViewController, let placeDescriptionObject = sourceViewController.placeDescriptionObject {
            
            add(placeDescriptionObject.toJsonObject(), pname: placeDescriptionObject.name)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object (and model) to the new view controller.
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "PlaceDetail" {
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.selectedPlace = names[indexPath.row]
            viewController.placeNames = names
            viewController.pdlo = placeDescriptionLibraryObject
        }
    }
}
