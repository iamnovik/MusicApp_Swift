import SwiftUI
import Firebase

struct AlbumList: View {
    let onlyFavourites: Bool
    @State private var albums: [Album] = []
    @State private var userData: UserData? = nil
    
    init(onlyFavourites: Bool) {
        self.onlyFavourites = onlyFavourites
    }
    
    var body: some View {
        if let user = Auth.auth().currentUser, let userId = user.uid as? String {
            AlbumListView(userUid: userId)
        } else {
            Text("User not logged in")
        }

    }
    
    private func fetchAlbums(for userUid: String) {
        DatabaseService(uid: userUid).getAlbums { albums in
            self.albums = albums
        }
        
        DatabaseService(uid: userUid).getUserData { userData in
            self.userData = userData
        }
        
        // Обновляем флаг isFav для каждого альбома
        guard let data = userData else{ return}
                for album in self.albums {
                    if ((data.favAlbums.contains(album.uid))) {
                        album.isFav = true
                    }
                }
        
        
    }
    
    private func filteredAlbums() -> [Album] {
        guard let userData = userData else { return albums }
        var filteredAlbums = albums
        if onlyFavourites {
            filteredAlbums = filteredAlbums.filter { userData.favAlbums.contains($0.uid) }
        }
        return filteredAlbums
    }
    
    private func AlbumListView(userUid: String) -> some View {
            fetchAlbums(for: userUid)
            return List(filteredAlbums(), id: \.uid) { album in
                AlbumTile(album: album, userData: userData)
                    .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120) // Растягиваем изображение по ширине и устанавливаем максимальную высоту
            }
        }
}

