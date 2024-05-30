//
//  AlbumInfo.swift
//  WHOA_iOS
//
//  Created by KSH on 3/13/24.
//

import Photos

struct AlbumInfo: Identifiable {
    let id: String?
    let name: String
    let album: PHFetchResult<PHAsset>
    
    init(fetchResult: PHFetchResult<PHAsset>, albumName: String) {
        id = nil
        name = albumName
        album = fetchResult
    }
}
