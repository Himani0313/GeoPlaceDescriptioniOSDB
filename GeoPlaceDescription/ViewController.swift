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
 * Purpose: Purpose: iOS app to view and manage place descriptions fetched from JSON file
 *
 * Ser423 Mobile Applications
 * @author Himani Shah Himani.shah@asu.edu
 *         Software Engineering, CIDSE, ASU Poly
 * @version March 2017
 */


import UIKit

class ViewController: UIViewController , UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    //Mark: Properties
    
    @IBOutlet weak var displayDescription: UITextField!
    @IBOutlet weak var displayCategory: UITextField!
    @IBOutlet weak var displayAddressTitle: UITextField!
    @IBOutlet weak var displayAddress: UITextView!
    @IBOutlet weak var displayLatitude: UITextField!
    @IBOutlet weak var displayLongitude: UITextField!
    @IBOutlet weak var displayElevation: UITextField!
    @IBOutlet weak var placePicker: UIPickerView!
    @IBOutlet weak var gcdDisplay: UITextField!
    @IBOutlet weak var bearingDisplay: UITextField!
    var places : PlaceDescription = PlaceDescription()
    var selectedPlace:String = "unknown"
    var placeNames = [String]()
    var pdlo : PlaceDescriptionLibrary = PlaceDescriptionLibrary()
    var toPlace : PlaceDescription = PlaceDescription()
    
    @IBAction func UpdatePlaces(_ sender: Any) {
        places.description = displayDescription.text!
        places.category = displayCategory.text!
        places.addresstitle = displayAddressTitle.text!
        places.address = displayAddress.text!
        places.elevation = Double(displayElevation.text!)!
        places.latitude = Double(displayLatitude.text!)!
        places.longitude = Double(displayLongitude.text!)!
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        displayName.text = "\(places[selectedPlace]!.name)"
//        displayDescription.text = "\(places[selectedPlace]!.description)"
//        displayCategory.text = "\(places[selectedPlace]!.category)"
//        displayAddressTitle.text = "\(places[selectedPlace]!.addresstitle)"
//        displayAddress.text = "\(places[selectedPlace]!.address)"
//        displayLatitude.text = "\(places[selectedPlace]!.latitude)"
//        displayLongitude.text = "\(places[selectedPlace]!.longitude)"
//        displayElevation.text = "\(places[selectedPlace]!.elevation)"
        self.title = places.name
        
        displayDescription.text = places.description
        displayCategory.text = places.category
        displayAddressTitle.text = places.addresstitle
        displayAddress.text = places.address
        displayElevation.text = String(format:"%f", places.elevation)
        displayLatitude.text = String(format:"%f", places.latitude)
        displayLongitude.text = String(format:"%f", places.longitude)
        self.placePicker.dataSource = self
        self.placePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.displayDescription.resignFirstResponder()
        self.displayAddressTitle.resignFirstResponder()
        self.displayAddress.resignFirstResponder()
        self.displayElevation.resignFirstResponder()
        self.displayLatitude.resignFirstResponder()
        self.displayLongitude.resignFirstResponder()
    }
    
    // UITextFieldDelegate Method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.displayDescription.resignFirstResponder()
        self.displayAddressTitle.resignFirstResponder()
        self.displayAddress.resignFirstResponder()
        self.displayElevation.resignFirstResponder()
        self.displayLatitude.resignFirstResponder()
        self.displayLongitude.resignFirstResponder()
        return true
    }
    // MARK: -- UIPickerVeiwDelegate method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPlace = placeNames[row]
        toPlace = pdlo.getPlaceDescription(placeTitle: selectedPlace)
        calcGCD(toPlace: toPlace)
        calcBearing(toPlace: toPlace)
    }
    
    // UIPickerViewDelegate method
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeNames[row]
    }
    
    // MARK: -- UIPickerviewDataSource method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerviewDataSource method
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeNames.count
    }
    func calcGCD(toPlace : PlaceDescription){
        let DEG_TO_RAD = 0.017453292519943295769236907684886
        let EARTH_RADIUS_IN_METERS = 6372797.560856
        
        let latitudeArc  = (places.latitude - toPlace.latitude) * DEG_TO_RAD
        let longitudeArc = (places.longitude - toPlace.longitude) * DEG_TO_RAD
        var latitudeH = sin(latitudeArc * 0.5)
        latitudeH *= latitudeH
        var lontitudeH = sin(longitudeArc * 0.5)
        lontitudeH *= lontitudeH
        let tmp = cos(places.latitude*DEG_TO_RAD) * cos(toPlace.latitude*DEG_TO_RAD)
        let gcd = EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH))
        gcdDisplay.text = String(gcd)
    }
    func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
    func calcBearing(toPlace : PlaceDescription) {
        let lat1 = degreesToRadians(degrees: places.latitude)
        let lon1 = degreesToRadians(degrees: places.longitude)
        
        let lat2 = degreesToRadians(degrees: toPlace.latitude)
        let lon2 = degreesToRadians(degrees: toPlace.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        bearingDisplay.text = String(radiansToDegrees(radians: radiansBearing))
    }
}

