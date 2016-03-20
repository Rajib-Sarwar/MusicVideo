//
//  MusicVideos.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 3/20/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import Foundation

class Videos {
    
    private var _vName: String
    private var _vRights: String
    private var _vPrice: String
    private var _vImageUrl: String
    private var _vArtist: String
    private var _vVideoUrl: String
    private var _vImid: String
    private var _vGenre: String
    private var _vLinkToiTunes: String
    private var _vReleaseDte: String
    
    var vName: String {
        return _vName
    }
    
    var vRights: String {
        return _vRights
    }
    
    var vPrice: String {
        return _vPrice
    }
    
    var vImageUrl: String {
        return _vImageUrl
    }
    
    var vArtist: String {
        return _vArtist
    }
    
    var vVideoUrl: String {
        return _vVideoUrl
    }
    
    var vImid: String {
        return _vImid
    }
    
    var vGenre: String {
        return _vGenre
    }
    
    var vLinkToiTunes: String {
        return _vLinkToiTunes
    }
    
    var vReleaseDte: String {
        return _vReleaseDte
    }
    
    init(data: JSONDictionary) {
        
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
                self._vName = vName
        } else {
            self._vName = ""
        }
        
        if let rights = data["rights"] as? NSDictionary,
            vRights = rights["label"] as? String {
                self._vRights = vRights
        } else {
            self._vRights = ""
        }
        
        if let price = data["im:price"] as? NSDictionary,
            vPrice = price["label"] as? String {
                self._vPrice = vPrice
        } else {
            self._vPrice = ""
        }
        
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
                _vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        } else {
            _vImageUrl = ""
        }
        
        if let artist = data["im:artist"] as? NSDictionary,
            vArtist = artist["label"] as? String {
                self._vArtist = vArtist
        } else {
            self._vArtist = ""
        }
        
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
                self._vVideoUrl = vVideoUrl
        } else {
            _vVideoUrl = ""
        }
        
        if let imid = data["id"] as? JSONDictionary,
            immid = imid["attributes"] as? JSONDictionary,
            vImid = immid["im:id"] as? String {
                self._vImid = vImid
        } else {
            _vImid = ""
        }
        
        if let genre = data["category"] as? JSONDictionary,
            ggenre = genre["attributes"] as? JSONDictionary,
            vGenre = ggenre["term"] as? String {
                self._vGenre = vGenre
        } else {
            _vGenre = ""
        }
        
        if let link = data["id"] as? JSONDictionary,
            vlink = link["label"] as? String {
                self._vLinkToiTunes = vlink
        } else {
            _vLinkToiTunes = ""
        }
        
        if let releaseDate = data["im:releaseDate"] as? JSONDictionary,
            releaseDte = releaseDate["attributes"] as? JSONDictionary,
            vReleaseDte = releaseDte["label"] as? String {
                self._vReleaseDte = vReleaseDte
        } else {
            self._vReleaseDte = ""
        }
        
    }
}