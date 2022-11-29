//
//  FirebaseDocument.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 10/07/2022.
//

struct FirebaseDocument {
    var firstCollection: String
    var firstDocument: String
    var secondCollection: String
    var secondDocument: String?
    
    init(firstCollection: String, firstDocument: String, secondCollection: String, secondDocument: String?){
        self.firstCollection = firstCollection
        self.firstDocument = firstDocument
        self.secondCollection = secondCollection
        self.secondDocument = secondDocument
    }
}
