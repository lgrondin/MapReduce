//
//  ViewController.swift
//  Map Reduce
//
//  Created by Lionel Grondin on 06/10/2016.
//  Copyright © 2016 Lionel Grondin. All rights reserved.
//

import UIKit

class MapResponse
{
    public var word : String
    public var value : Int
    
    init(word : String)
    {
        self.word = word
        self.value = 1
    }
}

class SortResponse
{
    public var word : String
    public var values : [Int]
    
    init(word : String)
    {
        self.word = word
        self.values = [1]
    }
    
    public func add()
    {
        self.values.append(1)
        
    }
    
}


class ViewController: UIViewController, UITextFieldDelegate
{
    /**************************************
    Funcions and variables used to link with the user interface
    ***************************************/
    
    //Link with the UI Text Field
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    
    //Link with the UI output Label
    @IBOutlet weak var label1: UITextView!
    @IBOutlet weak var label2: UITextView!
    @IBOutlet weak var label3: UITextView!
    
    //Link with the UI Buttons
    @IBAction func performAction(_ sender: UIButton)
    {
 
        if let buttonIdentifier = sender.currentTitle
        {
            field1.resignFirstResponder()
            field2.resignFirstResponder()
            field3.resignFirstResponder()
            label1.resignFirstResponder()
            label2.resignFirstResponder()
            label3.resignFirstResponder()
            
            switch buttonIdentifier
            {
            case "Map Field 1" :
                mapFunction(phrase: field1.text!)
                break
                
            case "Map Field 2" :
                mapFunction(phrase: field2.text!)
                break
                
            case "Map Field 3" :
                mapFunction(phrase: field3.text!)
                break
                
            case "Sort and Shufle" :
                sortFunction()
                break
                
            case "Reduce 1" :
                reduceFunction(startIndex: 0, stopIndex: (sortResponseArray.count)/3           )
                break
                
            case "Reduce 2" :
                reduceFunction(startIndex: (sortResponseArray.count)/3+1, stopIndex: (sortResponseArray.count)/3*2)
                break
            
            case "Reduce 3" :
                reduceFunction(startIndex: (sortResponseArray.count)/3*2+1, stopIndex: (sortResponseArray.count)-1)
                break
            case "Reset" :
                field1.text = ""
                field2.text = ""
                field3.text = ""
                label1.text = ""
                label2.text = ""
                label3.text = ""
                mapResponseArray = []
                sortResponseArray = []
                ReduceResponseArray = [:]
                break
                
            default :
                break
            }
            
        }
    }
    
    //function to allow the keyboard to disapear once the field are complete
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
    
    

    /**************************************
     Funcions and variables used for the map reduce algorithm
     ***************************************/


    
    //Array where the maps functions will write his outputs
    var mapResponseArray : [MapResponse] = []
    
    //Array where the sort function will write his output
    var sortResponseArray : [SortResponse] = []
    
    //Array where the Reduces functions will write his outpouts
    var ReduceResponseArray : [String : Int] = [:] //This is a dictionary (specific array in swift)
    
    
    //The map function, that take a string and add each word as a MapRespond Object in mapResponseArray
    func mapFunction( phrase: String)
    {
        
        //Cut the the string into an array of word
        let wordCollecion : [String] = phrase.components(separatedBy: " ")
        
        //For each word, create a mapResponse object (with 1 as the value) and add it to mapReponse Array
        for newWord2 in wordCollecion
        {
            let newMapResponse = MapResponse(word: newWord2)
            mapResponseArray.append(newMapResponse)
            
        }
        
        //Show the mapResponseArray in the label1 of the UI
        label1.text = nil
        for tmp in mapResponseArray
        {
            label1.text = label1.text! + "(\(tmp.word),  \(tmp.value))\n"
        }
        
    }
    
    //The Sort function, that will analyse the mapResponseArray and consolidate the same word together in the sortResponseArray
    func sortFunction ()
    {
        //Erase the sortReponseArray
        sortResponseArray = []
        
        //For each object in mapReponseArray
        for mapResponse in mapResponseArray
        {
            
            var alreadyExistInSortResponseArray = false
            
            //For each object in sortResponseArray
            for sortResponse in sortResponseArray
            {
                // if the word in mapResponse Array is the same that one in sortReponseArray, just add a 1 in the 'value' array
                if sortResponse.word == mapResponse.word
                {
                    sortResponse.add()
                    alreadyExistInSortResponseArray = true
                }
                
            }
            
            //if there it doesn't fond the word, create a new sortResponse object and add it in sortRespnseArray
            if alreadyExistInSortResponseArray == false
            {
                let newSortResponse = SortResponse (word: mapResponse.word)
                sortResponseArray.append(newSortResponse)
            }
        }
        
        //Sort the sortReponseArray by his word property
        sortResponseArray = sortResponseArray.sorted(by: { $0.word.uppercased() < $1.word.uppercased() })
        
        
        //Show the sortResponseArray in the label2 of the UI
        label2.text = nil
        for tmp in sortResponseArray
        {
            label2.text = label2.text + "(\(tmp.word), \(tmp.values))\n"


        }
        
        
    }
    
    //The reduce function, that for each object in sortReponseArray betwheen 2 indexes (received in parametters) will reduce the value array into a int that count the number of values
    func reduceFunction (startIndex : Int , stopIndex: Int)
    {
        //for each object in sortResponseArray that index is between startIndex and stopIndex
        for var i in startIndex...stopIndex
        {
            let sortResponse = sortResponseArray[i]
            
            //create an reduceResponse object and add it to reduceResponseArray
            ReduceResponseArray[sortResponse.word] = sortResponse.values.count
        }
        
        //Show the reduceResponseArray in the label3 of the UI
        label3.text = nil
        for tmp in ReduceResponseArray.sorted(by: { $0.key.uppercased() < $1.key.uppercased() })
        {
            label3.text = label3.text + "(\(tmp.key), \(tmp.value))\n"
        }
        
    }
    


   


}



