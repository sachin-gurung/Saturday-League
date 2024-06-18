////
////  FirestoreManager.swift
////  Saturday League
////
////  Created by Sachin Gurung on 6/18/24.
////
//
//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//class FirestoreManager: ObservableObject {
//    private var db = Firestore.firestore()
//    
//    @Published var teams: [Team] = []
//    
//    init(){
//        fetchTeams()
//    }
//    
//    func fetchTeams() {
//        db.collection("teams").order(by: "points", descending: true).addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//            
//            self.teams = querySnapshot?.documents.compactMap { document in
//                try? document.data(as: Team.self)
//            } ?? []
//        }
//    }
//    
//    func addTeam(_ team: Team) {
//        do {
//            _ = try db.collection("teams").addDocument(from: team)
//        } catch let error {
//            print("Error writing team to Firestore: \(error)")
//        }
//    }
//    
//    func updateTeam(_ team: Team) {
//        if let documentId = team.id?.uuidString {
//            do {
//                try db.collection("teams").document(documentId).setData(from: team)
//            } catch let error {
//                print ("Error updating team in Firestore: \(error)")
//            }
//        }
//    }
//}
