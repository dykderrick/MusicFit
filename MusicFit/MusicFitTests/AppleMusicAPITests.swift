//
//  AppleMusicAPITests.swift
//  MusicFitTests
//
//  Created by Derrick Ding on 6/25/23.
//

import XCTest

final class AppleMusicAPITests: XCTestCase {
    func testGetAppleMusicStorefrontID() async {
        let storefrontID = await AppleMusicAPIBase.getAppleMusicStorefrontID()
        
        XCTAssertNotNil(storefrontID)
    }
    
    func testGetAppleMusicCatalogSong() async {
        let catalogSong = await AppleMusicAPIBase.getAppleMusicCatalogSong(id: "1590368453", atStore: "us")
        
        XCTAssertNotNil(catalogSong, "Catalog Song nil")
    }
    
    func testGetPersonalSongRating() async {
        let userRatingLikes = await AppleMusicAPIBase.getPersonalSongRating(id: "1125331135")
        let userRatingDislikes = await AppleMusicAPIBase.getPersonalSongRating(id: "1686241815")
        let userRatingUnset = await AppleMusicAPIBase.getPersonalSongRating(id: "1590368453")
        
        XCTAssertEqual(userRatingLikes, .likes)
        XCTAssertEqual(userRatingDislikes, .dislikes)
        XCTAssertEqual(userRatingUnset, .unset)
    }
    
    func testGetAllLibraryPlaylists() async {
        let playlists = await AppleMusicAPIBase.getAllLibraryPlaylists()
                
        XCTAssertNotNil(playlists)
    }
    
    func testGetLibraryPlaylist() async {
        let testPlaylistId = "p.aJe00RDi3VKaQJa"
        let playlist = await AppleMusicAPIBase.getLibraryPlaylist(id: testPlaylistId)
        
        XCTAssertNotNil(playlist)
    }
    
    func testCreateLibraryPlaylist() async {
        let playlist = await AppleMusicAPIBase.createLibraryPlaylist(
            name: "RapidAPITestPlaylistForRootByAlamofire",
            description: "This is a test playlist at root created by RapidAPI",
            containing: ["1200868874", "1456232983"],
            at: "p.playlistsroot"
        )
                
        XCTAssertNotNil(playlist)
    }
    
    func testCreateLibraryPlaylistFolder() async {
        let folder = await AppleMusicAPIBase.createLibraryPlaylistFolder(name: "RapidAPITestPlaylistFolderByAlamofire", at: "p.playlistsroot")
        
        XCTAssertNotNil(folder)
    }
}
