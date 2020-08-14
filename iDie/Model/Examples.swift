//
//  Examples.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//
//  Beispiele aus Kapitel 2 der Bachelorarbeit

import Foundation

var beispielVar = 0
let beispielLet = "Beispiel"

var beispielKonkretVar: Double = 22
let beispielKonkretLet: Character = "t"


let beispielDictonary = [
    "iOS": "iPhone",
    "watchOS": "Apple Watch",
    "iPadOS": "iPad"
]

let beispielDictonaryMitArray = [
    "iPhone": ["11 Pro", "11", "XS", "X"],
    "Apple Watch": ["Series 5", "Series 4", "Series 3"],
    "iPad": ["Pro", "Air", "Mini"]
]

let beispielDictonaryMitArray2 = [
    ["11 Pro", "11", "XS", "X"]: "iPhone"
    
]



func beispiel(){
    
    for zahl in 0...22{
        print("durchlauf: \(zahl)")
    }
    
    let tiere = ["Hund", "Katze", "Maus"]
    
    for tier in tiere{
        print("Mein Haustier: \(tier)")
    }
    
}


func schreibeHallo(){
    print("Hallo!")
}

public func schreibeHalloAn(_ name: String){
    print("Hallo, \(name)!")
}

private func begruessePerson(name: String, begruessung: String) -> String{
    return "\(begruessung), \(name)!"
}

internal func gebePersonMitAlter(name: String, alter: Int) -> (String, Int){
    return (name, alter)
}

fileprivate func aufruf(){
    schreibeHallo()
    schreibeHalloAn("Anna")
    let personenGegruessung = begruessePerson(name: "Anna", begruessung: "Moin")
    let name = gebePersonMitAlter(name: "Peter", alter: 22).0
    let alter = gebePersonMitAlter(name: "Peter", alter: 22).1
    print(personenGegruessung + name + String(alter))
}

class Person {
    init(name: String, alter: Int) {
        self.name = name
        self.alter = alter
    }
    var name: String
    var alter: Int
}

var beispielPerson = Person(name: "Muster", alter: 22)

