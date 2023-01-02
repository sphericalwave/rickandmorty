//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    
    @StateObject var characterProvider = CharacterProvider()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            Characters()
                .environmentObject(characterProvider)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            sleep(2)
        }
        return true
    }
}
