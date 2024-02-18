import XCTest
@testable import MockIO

final class InputTests: XCTestCase {
    func testGetInt() throws {
        var io = Input("23")
        let x = try io.getInt()
        XCTAssertEqual(x, 23)
    }

    func testGetDouble() throws {
        var io = Input("23.5")
        let x = try io.getDouble()
        XCTAssertEqual(x, 23.5)
    }

    func testGetMultipleInts() throws {
        var io = Input("""
        10 11 12
        13 14
        15 16
        """)
        for i in 10...16 {
            let x = try io.getInt()
            XCTAssertEqual(i, x)
        }
    }

    func testGetMultipleDoubles() throws {
        var io = Input("""
        10.0 11 12
        13 14.0
        15 16
        """)
        for i in 10...16 {
            let x = try io.getDouble()
            XCTAssertEqual(Double(i), x)
        }
    }

    func testGetString() throws {
        var io = Input("testing")
        let s = try io.getString()
        XCTAssertEqual(s, "testing")
    }

    func testGetTwoStringSeparateLines() throws {
        var io = Input("testing\nhello world")
        let s1 = try io.getString()
        XCTAssertEqual(s1, "testing")
        let s2 = try io.getString()
        XCTAssertEqual(s2, "hello world")
    }

    func testGetTwoStringSeparateLinesUntil() throws {
        var io = Input("testing\nhello world")
        let s1 = try io.getString()
        XCTAssertEqual(s1, "testing")
        let s2 = try io.getString(until: " ")
        XCTAssertEqual(s2, "hello")
        let s3 = try io.getString(until: " ")
        XCTAssertEqual(s3, "world")
    }
}

final class OutputTests: XCTestCase {
    func testInt() {
        var io = Output()
        io.output(42)
        XCTAssertEqual(io.outputString, "42\n")
    }

    func testTwoInts() {
        var io = Output()
        io.output(23, 42)
        XCTAssertEqual(io.outputString, "23 42\n")
    }

    func testSep() {
        var io = Output()
        io.output(23, 42, sep: ",")
        XCTAssertEqual(io.outputString, "23,42\n")
        io.output(23, 42, sep: ", ")
        XCTAssertEqual(io.outputString, "23,42\n23, 42\n")
    }

    func testResetString() {
        var io = Output()
        io.output(23, 42, sep: ",")
        XCTAssertEqual(io.outputString, "23,42\n")
        io.reset()
        XCTAssertEqual(io.outputString, "")
        io.output(1, 2, 3)
        XCTAssertEqual(io.outputString, "1 2 3\n")
    }

    func testEnd() {
        var io = Output()
        io.output(23, end: " ")
        io.output(42)
        XCTAssertEqual(io.outputString, "23 42\n")


    }

}
