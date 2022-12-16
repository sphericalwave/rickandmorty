/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A class for caching character data.
*/

import Foundation

/// A class to hold a CacheEntry.
final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) { self.entry = entry }
}

/// An enumeration of cache character cache entries.
enum CacheEntry {
    case inProgress(Task<Data, Error>)
    case ready(Data)
}
