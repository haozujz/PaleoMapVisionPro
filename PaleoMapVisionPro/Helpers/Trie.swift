//
//  Trie.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 20/11/2023.
//

import Foundation

class TrieNode<T: Hashable> {
    var value: T?
    weak var parent: TrieNode?
    var children: [T: TrieNode] = [:]
    var isTerminating = false

    init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }

    func add(child: T) -> TrieNode {
        if let existingChild = children[child] {
            return existingChild
        } else {
            let childNode = TrieNode(value: child, parent: self)
            children[child] = childNode
            return childNode
        }
    }
}

class Trie {
    typealias Node = TrieNode<Character>
    private let root: Node

    init() {
        root = Node()
    }

    func insert(word: String) {
        guard !word.isEmpty else { return }

        var currentNode = root
        let characters = Array(word.lowercased())
        var currentIndex = 0

        while currentIndex < characters.count {
            let character = characters[currentIndex]
            if let child = currentNode.children[character] {
                currentNode = child
            } else {
                currentNode = currentNode.add(child: character)
            }
            currentIndex += 1
        }

        if currentIndex == characters.count {
            currentNode.isTerminating = true
        }
    }

    func search(word: String) -> Bool {
        guard !word.isEmpty else { return false }

        var currentNode = root
        let characters = Array(word.lowercased())

        for character in characters {
            guard let child = currentNode.children[character] else {
                return false
            }
            currentNode = child
        }

        return currentNode.isTerminating
    }

    func startsWith(prefix: String) -> Bool {
        guard !prefix.isEmpty else { return false }

        var currentNode = root
        let characters = Array(prefix.lowercased())

        for character in characters {
            guard let child = currentNode.children[character] else {
                return false
            }
            currentNode = child
        }

        return true
    }

    func collectWords(startingWith prefix: String) -> [String] {
        var words = [String]()
        let characters = Array(prefix.lowercased())
        var currentNode = root

        for character in characters {
            guard let child = currentNode.children[character] else {
                return []
            }
            currentNode = child
        }

        collectWords(node: currentNode, prefix: prefix, words: &words)
        return words
    }

    private func collectWords(node: Node, prefix: String, words: inout [String]) {
        if node.isTerminating {
            words.append(prefix)
        }

        for (childKey, childNode) in node.children {
            collectWords(node: childNode, prefix: prefix + String(childKey), words: &words)
        }
    }
}

extension Trie {
    func countWords() -> Int {
        return countWords(node: root)
    }

    private func countWords(node: Node) -> Int {
        var count = 0
        if node.isTerminating {
            count += 1
        }
        for childNode in node.children.values {
            count += countWords(node: childNode)
        }
        return count
    }
}

extension Trie {
    func serialize() -> Data? {
        var words: [String] = []
        collectWords(node: root, prefix: "", words: &words)
        return try? JSONEncoder().encode(words)
    }
    
    func deserialize(from data: Data) {
            guard let words = try? JSONDecoder().decode([String].self, from: data) else { return }
            for word in words {
                insert(word: word)
        }
    }
}


func saveTrieToFile(trie: Trie, fileName: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileURL = documentDirectory.appendingPathComponent(fileName)

    if let data = trie.serialize() {
        do {
            try data.write(to: fileURL)
            print("Trie saved to \(fileURL)")
        } catch {
            print("Error saving trie: \(error)")
        }
    }
}

func loadTrieFromFile(trie: Trie, fileName: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileURL = documentDirectory.appendingPathComponent(fileName)

    do {
        let data = try Data(contentsOf: fileURL)
        trie.deserialize(from: data)
        print("Trie loaded from \(fileURL)")
    } catch {
        print("Error loading trie: \(error)")
    }
}

func loadTrieFromBundle(trie: Trie, fileName: String) {
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("Trie file not found in bundle")
        return
    }

    do {
        let data = try Data(contentsOf: fileURL)
        trie.deserialize(from: data)
        print("Trie loaded from \(fileURL)")
    } catch {
        print("Error loading trie: \(error)")
    }
}
