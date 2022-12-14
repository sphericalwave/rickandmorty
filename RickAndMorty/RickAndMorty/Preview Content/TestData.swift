//
//  TestData.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-15.
//

import Foundation

let testJohnnyDepp: Data = """
    {
        "id":183,
        "name":"Johnny Depp",
        "status":"Alive",
        "species":"Human",
        "type":"",
        "gender":"Male",
        "origin":{
            "name":"Earth (C-500A)",
            "url":"https://rickandmortyapi.com/api/location/23"
        },
        "location":{
            "name":"Earth (C-500A)",
            "url":"https://rickandmortyapi.com/api/location/23"
        },
        "image":"https://rickandmortyapi.com/api/character/avatar/183.jpeg",
        "episode":["https://rickandmortyapi.com/api/episode/8"],
        "url":"https://rickandmortyapi.com/api/character/183",
        "created":"2017-12-29T18:51:29.693Z"
    }
""".data(using: .utf8)!
