import Foundation

public enum InputError: Error {
    case empty
    case notInt(String)
    case notDouble(String)
}

/// for mocking Input with the supplied string
public struct Input {
    private var s: Substring

    /// init with string to use as input
    /// - Parameter s: string to use as input
    public init(_ s: String) {
        self.s = s[...]
    }

    /// try to get an Int as the next item from the input
    /// if successful it removes it and the space afterwards from the input before returning the Int
    /// - Throws: InputError.empty if out of input or InputError.notInt if couldn't find an Int up to the next space
    /// - Returns: Int from the input string
    public mutating func getInt() throws -> Int {
        // skip whitespace
        let whiteSpace = s.prefix(while: { $0.isWhitespace })
        s = s.dropFirst(whiteSpace.count)
        guard !s.isEmpty else { throw InputError.empty }
        // assume until next whitespace is the number
        let prefix = s.prefix(while: { !$0.isWhitespace })
        s = s.dropFirst(prefix.count + 1)
        if let x = Int(prefix) {
            return x
        } else {
            throw InputError.notInt(String(prefix))
        }
    }

    /// try to get a Double as the next item from the input
    /// if successful it removes it and the space afterwards from the input before returning the Double
    /// - Throws: InputError.empty if out of input or InputError.notDouble if couldn't find a Double up to the next space
    /// - Returns: Double from the input string
    public mutating func getDouble() throws -> Double {
        // skip whitespace
        let whiteSpace = s.prefix(while: { $0.isWhitespace })
        s = s.dropFirst(whiteSpace.count)
        guard !s.isEmpty else { throw InputError.empty }
        // assume until next whitespace is the number
        let prefix = s.prefix(while: { !$0.isWhitespace })
        s = s.dropFirst(prefix.count + 1)
        if let x = Double(prefix) {
            return x
        } else {
            throw InputError.notDouble(String(prefix))
        }
    }

    /// try to get a String as the next item from the input
    /// if input string is not empty, the portion it returns is removed from the input string before returning
    /// - Throws: InputError.empty if out of input
    /// - Returns: String from the input string
    public mutating func getString(until: Character? = "\n") throws -> String {
        guard !s.isEmpty else { throw InputError.empty }
        guard let until else {
            defer { s = "" }
            return String(s)
        }
        let prefix = s.prefix(while: { $0 != until })
        s = s.dropFirst(prefix.count + 1)
        return String(prefix)
    }
    
    /// tries to get an array of Int as the next item from the input
    /// - Throws : InputError.empty if out of input, or InputError.notInt if data is not all Int
    /// - Parameter until: process all characters until this character; pass `nil` to process rest of input
    /// - Returns: array of Int from the input
    public mutating func getArrayOfInt(until: Character? = "\n") throws -> [Int] {
        let strings = try skippingWhitespaceSplittingOnWhitespace(until: until)
        var values: [Int] = []
        for s in strings {
            if let x = Int(s) {
                values.append(x)
            } else {
                throw InputError.notInt(String(s))
            }
        }
        return values
    }

    /// tries to get an array of Double as the next item from the input
    /// - Throws : InputError.empty if out of input, or InputError.notDouble if data is not all Double
    /// - Parameter until: process all characters until this character; pass nil to process rest of input
    /// - Returns: array of Double from the input
    public mutating func getArrayOfDouble(until: Character? = "\n") throws -> [Double] {
        let strings = try skippingWhitespaceSplittingOnWhitespace(until: until)
        var values: [Double] = []
        for s in strings {
            if let x = Double(s) {
                values.append(x)
            } else {
                throw InputError.notDouble(String(s))
            }
        }
        return values
    }
    
    /// helper function to skip past any whitespace and then get the to the `until` character (pass `nil` to go to end of input) and then splits the input on any whitespace character
    /// - Parameter until: process and remove input to this character (pass `nil` to process all remaining input
    /// - Returns: an array of Substring splitting the processed input on any whitespace characters
    private mutating func skippingWhitespaceSplittingOnWhitespace(until: Character? = "\n") throws -> [Substring] {
        // skip whitespace
        let whiteSpace = s.prefix(while: { $0.isWhitespace })
        s = s.dropFirst(whiteSpace.count)
        let prefix: Substring
        guard !s.isEmpty else { throw InputError.empty }
        if let until {
            prefix = s.prefix(while: { $0 != until })
        } else {
            prefix = s
        }
        s = s.dropFirst(prefix.count + 1)
        return prefix.split(whereSeparator: { $0.isWhitespace } )
    }
}

/// for mocking output instead of using print directly
public struct Output {

    /// optional closure to call each time output changes; first parameter is old string, second parameter is complete updated string
    public var didChange: (String, String) -> Void = { _, _ in }

    /// String for keeping track of what is output
    public private(set) var outputString = ""

    /// add string representation of x to the output
    /// - Parameters:
    ///   - items: arbitrary number of CustomStringConvertible to add to string
    ///   - sep: String to add between each parameter (defaults to a space)
    ///   - end: String to add to input after adding all the items (defaults to a newline
    public mutating func output(_ items: CustomStringConvertible..., sep: String = " ", end: String = "\n") {
        let oldValue = outputString
        let s = items.map { String(describing: $0) }
        outputString += s.joined(separator: sep) + end
        didChange(oldValue, outputString)
    }

    /// reset output to an empty string
    public mutating func reset() {
        outputString = ""
    }

    /// print the output string to the output
    /// - Parameter resetString: if true, set outputString to empty string after printing
    public mutating func print(resetString: Bool = true) {
        Swift.print(outputString, separator: "")
        if resetString {
            reset()
        }
    }
}
