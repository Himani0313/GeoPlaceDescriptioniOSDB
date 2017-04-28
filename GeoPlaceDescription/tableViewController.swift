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
 * Purpose: Purpose: iOS app to view and manage place descriptions fetched from iOS core data and intialized by JSON file.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("view did load" )
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.names = placeDescriptionLibraryObject.getPlaceTitles()
        self.title = "Places List"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func navigateToNextViewController(){
//        self.performSegue(withIdentifier: "addPlace", sender: self)
//    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing row at: \(indexPath.row)")
        if editingStyle == .delete {
            let selectedPlace:String = names[indexPath.row]
            print("deleting the place \(selectedPlace)")
            placeDescriptionLibraryObject.remove(selectedPlace: selectedPlace)
            self.names = placeDescriptionLibraryObject.getPlaceTitles()
            tableView.deleteRows(at: [indexPath], with: .fade)
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
            let newIndexPath = IndexPath(row: names.count, section: 0)
            placeDescriptionLibraryObject.add(selectedPlace: placeDescriptionObject, placeTitle: placeDescriptionObject.name)
            names = placeDescriptionLibraryObject.getPlaceTitles()
            for place in names{
                print("\n\nPlace : "+place)
            }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            //self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object (and model) to the new view controller.
        NSLog("seque identifier is \(segue.identifier)")
        if segue.identifier == "PlaceDetail" {
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            let aPlace = placeDescriptionLibraryObject.getPlaceDescription(placeTitle: names[indexPath.row]) as PlaceDescription
            viewController.places = aPlace
            viewController.selectedPlace = names[indexPath.row]
            viewController.placeNames = names
            viewController.pdlo = placeDescriptionLibraryObject
        }
    }
}
