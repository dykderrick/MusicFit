//
//  PlaylistItem.swift
//  MusicFit
//
//  Created by Derrick Ding on 5/10/22.
//

import SwiftUI

struct PlaylistItem: View {
    @ObservedObject var musicFitPlaylistManager: MusicFitPlaylistManager
    let musicFitStatus: MusicFitStatus
    
    init(
        _ musicFitPlaylistManager: MusicFitPlaylistManager,
        status musicFitStatus: MusicFitStatus
    ) {
        self.musicFitPlaylistManager = musicFitPlaylistManager
        self.musicFitStatus = musicFitStatus
    }
    
    var body: some View {
        HStack(spacing: 40) {
            Image("\(musicFitStatus.rawValue)DefaultPlaylistCover")
                .resizable()
                .frame(width: 110.0, height: 110.0)
                .cornerRadius(20)
            
            VStack {
                Text(musicFitStatus.rawValue.uppercased())
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "45FFCC"))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width - 230)
                
                
                HStack {
                    Text("34")
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.musicFitGreen)
                    Spacer()
                        .frame(width: 75.0)
                }
                .padding(.trailing)
                .frame(width: 150.0)
                
                HStack {
                    Text(String(musicFitPlaylistManager.musicFitPlaylistTrackCount[musicFitStatus] ?? 0))
                        .foregroundColor(Color(hex: "848484"))
                        .foregroundColor(Color(hex: "848484"))
                    Text(" Songs")
                        .foregroundColor(Color(hex: "848484"))
                    Spacer()
                        .frame(width: 50.0)
                }
                .frame(width: 150.0)
            }
            .frame(height: 93.0)
            
            Spacer()
                .frame(width: 30.0)
        }
        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 7)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(.white).opacity(0.1))
        )
        .onAppear() {
            musicFitPlaylistManager.prepareMusicFitPlaylistTracks(musicFitStatus: musicFitStatus) { playlistTracksPreparedResult in
                // TODO: Handle here
                print(playlistTracksPreparedResult)
            }
        }
    }
}

struct PlaylistItem_Previews: PreviewProvider {
    static var previews: some View {
        let musicManager = AppleMusicManager()
        let fileHandler = FileHandler()
        let musicFitPlaylistManager = MusicFitPlaylistManager(musicManager: musicManager, fileHandler: fileHandler)
        
        Group {
            PlaylistItem(musicFitPlaylistManager, status: .Resting)
                .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            
            PlaylistItem(musicFitPlaylistManager, status: .Walking)
                .preferredColorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
