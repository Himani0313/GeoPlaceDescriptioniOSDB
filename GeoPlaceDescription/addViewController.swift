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
import os.log

class addViewController: UIViewController {
    var placeDescriptionObject : PlaceDescription?
    let placeDescriptionLibraryObject = PlaceDescriptionLibrary()
    @IBOutlet weak var nameDisplay: UITextField!
    @IBOutlet weak var descriptionDisplay: UITextField!
    @IBOutlet weak var categoryDisplay: UITextField!
    @IBOutlet weak var addTitleDisplay: UITextField!
    @IBOutlet weak var addStreetDisplay: UITextView!
    @IBOutlet weak var elevationDisplay: UITextField!
    @IBOutlet weak var latitudeDisplay: UITextField!
    @IBOutlet weak var longitudeDisplay: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancelbutton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
//    @IBAction func savebutton(_ sender: Any) {
//        placeDescriptionObject.name = nameDisplay.text!
//        placeDescriptionObject.description = descriptionDisplay.text!
//        placeDescriptionObject.category = categoryDisplay.text!
//        placeDescriptionObject.addresstitle = addTitleDisplay.text!
//        placeDescriptionObject.address = addStreetDisplay.text!
//        placeDescriptionObject.elevation = Float(elevationDisplay.text!)!
//        placeDescriptionObject.latitude = Float(latitudeDisplay.text!)!
//        placeDescriptionObject.longitude = Float(longitudeDisplay.text!)!
//        placeDescriptionLibraryObject.add(selectedPlace: placeDescriptionObject, placeTitle: nameDisplay.text!)
//        dismiss(animated: true, completion: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a Place"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        placeDescriptionObject = PlaceDescription(name: nameDisplay.text!, description: descriptionDisplay.text!, category: categoryDisplay.text!, addressTitle: addTitleDisplay.text!, addressStreet: addStreetDisplay.text!, elevation: Double(elevationDisplay.text!)!, latitude: Double(latitudeDisplay.text!)!, longitude: Double(longitudeDisplay.text!)!)
    }
    

}
