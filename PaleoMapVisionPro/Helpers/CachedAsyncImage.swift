//
//  CachedAsyncImage.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 24/12/2023.
//

import Foundation
import SwiftUI

@MainActor
struct CachedAsyncImage<Content: View>: View{
    private var key: String
    //private let scale: CGFloat
    //private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init (
        key: String,
        scale: CGFloat = 1.0,
        //transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.key = key
        //self.scale = scale
        //self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache.shared[key] {
            //let _ = print("loading image from cache: \(key)")
            content(.success(cached))
        } else {
            //let _ = print("Loading image from url: \(key)")
            AsyncImage(
                url: URL(string: key)
                //scale: scale,
                //transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success (let image) = phase {
            ImageCache.shared[key] = image
            //print("keys: \(ImageCache.shared.keys)")
        } else if case .failure = phase {
            //print("Loading image from url failed: \(key)")
        }
        return content(phase)
    }
}


class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private var cache: [String: Image] = [:]
    private var accessOrder: [String] = [] // For LRU
    private let maxItems = 20

    subscript(key: String) -> Image? {
        get {
            if let image = cache[key] {
                // Move accessed key to the end to mark it as recently used
                accessOrder.removeAll { $0 == key }
                accessOrder.append(key)
                return image
            }
            return nil
        }
        set {
            if let image = newValue {
                // Add or update the value
                cache[key] = image
                accessOrder.removeAll { $0 == key }
                accessOrder.append(key)

                // Remove the least recently used item if the cache exceeds maxItems
                if accessOrder.count > maxItems {
                    let leastRecentlyUsedKey = accessOrder.removeFirst()
                    cache.removeValue(forKey: leastRecentlyUsedKey)
                }
            } else {
                // Handle removal of items if needed
                cache.removeValue(forKey: key)
                accessOrder.removeAll { $0 == key }
            }
        }
    }
}
