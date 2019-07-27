//
//  Node.swift
//  SwiftTree
//
//  Created by cronycle on 26/07/2019.
//  Copyright © 2019 Cronycle. All rights reserved.
//

public class Node {
    weak var parent : Node?
    var value : String
    var displayText : String = ""
    
    var children : [Node] = []
    var relationToParent : Relation = .not
    var height : Int {
        get {
            return calculateHeight()
        }
    }
    
    init(value: String, parent : Node?, relationToParent : Relation = .and) {
        self.value = value
        self.parent = parent
        self.relationToParent = relationToParent
        parse(string: value)
    }
    
    func add(child: Node) {
        children.append(child)
    }
    
    func calculateHeight()-> Int {
        if children.count == 0 {
            return 0
        } else {
            return children.count + heightOfChildren()
        }
    }
    
    func heightOfChildren() -> Int {
        return children.compactMap({return $0.height}).reduce(0, {(x,y) in
            return x + y
        })
    }
    
    func parse(string : String, isBacktracking : Bool = false) {
        var negate = false
        if string.hasPrefix("not") || string.hasPrefix("-") { negate = true }
        var spaceSaparatedString = string.components(separatedBy: " ")
        spaceSaparatedString.removeAll(where: {$0 == ""})
        if !negate {
            configureGroups(spaceSaparatedString: spaceSaparatedString, isBacktracking: isBacktracking)
        } else {
            configureNegateGropus(spaceSaparatedString: spaceSaparatedString, isBacktracking: isBacktracking)
        }
    }
    
    func configureNegateGropus(spaceSaparatedString : [String],isBacktracking : Bool) {
        var newArray = spaceSaparatedString
        newArray.remove(at: 0)
        if isBacktracking {
            let node = Node.init(value: newArray.joined(separator: " "), parent: parent, relationToParent: .not)
            add(child: node)
        } else {
            self.relationToParent = .not
            configureGroups(spaceSaparatedString: newArray, isBacktracking: isBacktracking)
        }
    }
    
    func configureGroups(spaceSaparatedString : [String],isBacktracking : Bool) {
        var index = 0
        var indexesCovered : IndexSet = IndexSet()
        
        for word in spaceSaparatedString {
            if index == 0  && isBacktracking == false {
                if word.contains(")") {
                    let indexOfFirstBracket = word.firstIndex(of: ")")
                    if let index = indexOfFirstBracket {
                        let nextIndex = String.Index.init(utf16Offset: index.utf16Offset(in: value) + 1, in: value)
                        let zeroIndex = String.Index.init(utf16Offset: 0, in: value)
                        if value.indices.contains(nextIndex) {
                            let valueBeforeBracket = value[zeroIndex...index]
                            displayText += valueBeforeBracket
                            let lastIndex = value.indices.last!
                            let remainingString = value[nextIndex...lastIndex]
                            parent?.backTrack(string: String(remainingString))
                            return
                        }
                    }
                }
                displayText += word
            } else {
                switch word {
                case "and", "\n":
                    if spaceSaparatedString.indices.contains(index + 1) {
                        let nextIndexWord = spaceSaparatedString[index + 1]
                        if canAddNextWord(word: nextIndexWord) {
                            if children.count > 0 || isBacktracking {
                                let child = Node.init(value: nextIndexWord, parent: self,relationToParent: .and)
                                add(child: child)
                                indexesCovered.insert(index + 1)
                            } else {
                                displayText += " AND "
                            }
                        }
                    }
                case "or", ",":
                    if spaceSaparatedString.indices.contains(index + 1) {
                        let nextIndexWord = spaceSaparatedString[index + 1]
                        if canAddNextWord(word: nextIndexWord) {
                            if children.count > 0 || isBacktracking {
                                let child = Node.init(value: nextIndexWord, parent: self,relationToParent: .or)
                                add(child: child)
                                indexesCovered.insert(index + 1)
                            } else {
                                displayText += " OR "
                            }
                        }
                    }
                case "not", "-":
                    if spaceSaparatedString.indices.contains(index + 1) {
                        let nextIndexWord = spaceSaparatedString[index + 1]
                        indexesCovered.insert(index + 1)
                        if nextIndexWord.contains("("){
                            let arrySliceString = spaceSaparatedString[index+1...spaceSaparatedString.count-1].joined(separator: " ")
                            let relation : Relation = .not
                            let child = Node.init(value: arrySliceString, parent: self,relationToParent: relation)
                            add(child: child)
                            return
                        }
                        let child = Node.init(value: nextIndexWord, parent: self,relationToParent: .not)
                        add(child: child)
                    }
                default:
                    if word.contains("(") {
                        let arrySliceString = spaceSaparatedString[index...spaceSaparatedString.count-1].joined(separator: " ")
                        var relation : Relation = .and
                        if spaceSaparatedString.indices.contains(index - 1) {
                            let prevString = spaceSaparatedString[index - 1]
                            switch prevString {
                            case "and","\n":
                                relation = .and
                            case "or", ",":
                                relation = .or
                            case "not", "-":
                                relation = .not
                            default:
                                break
                            }
                        }
                        let child = Node.init(value: arrySliceString, parent: self,relationToParent: relation)
                        add(child: child)
                        return
                    }
                    if word.contains(")") {
                        var splittedArray = word.components(separatedBy: ")")
                        var backtrackRemString = ""
                        
                        if splittedArray.count > 0 {
                            displayText += " " + splittedArray[0] + ")"
                            if splittedArray.count > 1 {
                                backtrackRemString += splittedArray[1]
                            }
                        }
                        if spaceSaparatedString.indices.contains(index + 1) {
                            let otherRemainingStringIfAny = spaceSaparatedString[index+1...spaceSaparatedString.count-1].joined(separator: " ")
                            if otherRemainingStringIfAny.count != 0 {
                                if parent != nil {
                                    parent?.backTrack(string: backtrackRemString + " " + otherRemainingStringIfAny)
                                    return
                                }
                            }
                        }
                    } else {
                        if !indexesCovered.contains(index) {
                            displayText += " " + word
                        }
                    }
                }
            }
            index += 1
        }
    }
    
    func backTrack(string : String) {
        parse(string: string, isBacktracking: true)
    }
    
    func canAddNextWord(word : String) -> Bool {
        switch word {
        case "and", "\n":
            return false
        case "or", ",":
            return false
        case "not", "-":
            return false
        default:
            if word.contains("(") {
                return false
            }
            if word.contains(")"){
                return true
            }
        }
        return true
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        var text = "\(displayText)".replacingOccurrences(of: "  ", with: " ")
        if !children.isEmpty {
            text += " {\n" + children.map { $0.description + " " + $0.relationToParent.rawValue + "\n" }.joined(separator: ", ") + "\n} "
        }
        return text
    }
}

extension Node : Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        if lhs.value == rhs.value
            && lhs.parent == rhs.parent
            && lhs.relationToParent == rhs.relationToParent
            && lhs.description == rhs.description {
            return true
        }
        return false
    }
}
