//
//  DatabaseServic.swift
//  music_app
//
//  Created by Novik Vladislav on 18.04.24.
//
import FirebaseFirestore
import Firebase

class DatabaseService: ObservableObject {
    let uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    private var db = Firestore.firestore()
    
    func createUserData() {
        db.collection("users").document(uid).setData([
            "firstname": "",
            "secondname": "",
            "birthdate": Timestamp(date: Date()),
            "sex": true,
            "address": "",
            "about": "",
            "favalbum": "DE",
            "favartist": "",
            "image": "avatar/Без имени-3.png",
            "albums_in_fav": 0,
            "inFavourites": []
        ])
    }
    
    func updateUserData(
        firstname: String,
        secondname: String,
        birthdate: Date,
        sex: Bool,
        address: String,
        about: String,
        favalbum: String,
        favartist: String
    ) {
        db.collection("users").document(uid).updateData([
            "firstname": firstname,
            "secondname": secondname,
            "birthdate": Timestamp(date: birthdate),
            "sex": sex,
            "address": address,
            "about": about,
            "favalbum": favalbum,
            "favartist": favartist
        ])
    }
    
    func updateUserfavAlbums(favAlbums: [String]) {
        db.collection("users").document(uid).updateData([
            "inFavourites": favAlbums
        ])
    }
    
    func deleteUserData() {
        db.collection("users").document(uid).delete()
    }
    
    private func userDataFromSnapshot(snapshot: DocumentSnapshot) -> UserData? {
        guard let data = snapshot.data() else { return nil }
        return UserData(
            uid: uid,
            firstname: data["firstname"] as? String ?? "",
            secondname: data["secondname"] as? String ?? "",
            birthdate: (data["birthdate"] as? Timestamp)?.dateValue() ?? Date(),
            sex: data["sex"] as? Bool ?? false,
            address: data["address"] as? String ?? "",
            image: data["image"] as? String ?? "",
            favalbum: data["favalbum"] as? String ?? "",
            favartist: data["favartist"] as? String ?? "",
            about: data["about"] as? String ?? "",
            favAlbums: data["inFavourites"] as? [String] ?? []
        )
    }
    
    func getUserData(completion: @escaping (UserData?) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error getting user data: \(error.localizedDescription)")
                completion(nil)
            } else if let snapshot = snapshot, snapshot.exists {
                let userData = self.userDataFromSnapshot(snapshot: snapshot)
                completion(userData)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    private func albumListFromSnapshot(snapshot: QuerySnapshot) -> [Album] {
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let uid = document.documentID
            let title = data["title"] as? String ?? ""
            let artist = data["artist"] as? String ?? ""
            let year = data["year"] as? Int ?? 0
            return Album(uid: uid, title: title, artist: artist, year: year)
        }
    }

    
    func getAlbums(completion: @escaping ([Album]) -> Void) {
        db.collection("albums").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting albums: \(error.localizedDescription)")
                completion([])
            } else if let snapshot = snapshot {
                let albums = self.albumListFromSnapshot(snapshot: snapshot)
                completion(albums)
            } else {
                completion([])
            }
        }
    }
}

