import SwiftUI

struct AlbumTile: View {
    @EnvironmentObject var databaseService: DatabaseService
    @State private var isFavorite: Bool
    
    let album: Album
    let userData: UserData?
    
    init(album: Album, userData: UserData?) {
        self.album = album
        self.userData = userData
        self._isFavorite = State(initialValue: album.isFav)
    }
    
    var body: some View {
        Button(action: {
            // Нажатие на ZStack
            // Можно добавить здесь любую логику, связанную с нажатием области, кроме перехода на AlbumDetailedView
        }) {
            ZStack {
                // PreviewImage в качестве заднего фона
                PreviewImage(path: "\(album.title)/preview.jpg")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(album.title)
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                                .shadow(color: .black, radius: 10, x: 2, y: 2)

                            Text(album.artist)
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                                .shadow(color: .black, radius: 10, x: 2, y: 2)
                            
                            Text(album.year.formatted())
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                                .shadow(color: .black, radius: 10, x: 2, y: 2)
                        }
                        .padding()

                        Spacer()

                        Button(action: {
                            // Обновляем статус "Избранное" альбома
                            _toggleFavorite()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(isFavorite ? .red : .gray)
                                .padding()
                        }
                        .contentShape(Rectangle())
                    }
                }
                .onAppear {
                    isFavorite = album.isFav
                }
            }
        }
        .background(
            NavigationLink(destination: AlbumDetailedView(album: album, folderPath: album.title+"/", userData: userData)) {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
        )
        .navigationBarBackButtonHidden(true)
    }

    
    private func _showAlbumDetailed() {
        
    }
    
    private func _toggleFavorite() {
        guard let userData = userData else { return }
        
        if isFavorite {
            userData.favAlbums.removeAll { $0 == album.uid }
        } else {
            userData.favAlbums.append(album.uid)
        }
        
        DatabaseService(uid: userData.uid).updateUserfavAlbums(favAlbums: userData.favAlbums)
        isFavorite.toggle()
    }
}

