import XCTest
@testable import MockIO

final class InputTests: XCTestCase {
    func testGetInt() throws {
        var io = Input(" 23")
        let x = try io.getInt()
        XCTAssertEqual(x, 23)
    }

    func testGetIntThrowsEmpty() throws {
        var io = Input("   ")
        do {
            let _ = try io.getInt()
            XCTFail("test should have thrown")
        } catch InputError.empty {

        } catch {
            XCTFail("test should have thrown empty error, but threw a different error")
        }
    }

    func testGetIntThrowsNotInt() throws {
        var io = Input(" abc  ")
        do {
            let _ = try io.getInt()
            XCTFail("test should have thrown")
        } catch InputError.notInt(_) {

        } catch {
            XCTFail("test should have thrown empty error, but threw a different error")
        }
    }

    func testGetDouble() throws {
        var io = Input("23.5")
        let x = try io.getDouble()
        XCTAssertEqual(x, 23.5)
    }

    func testGetMultipleInts() throws {
        var io = Input("""
        10   11 12
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

    func testArrayOfInt() throws {
        var io = Input(" 10  15  2 42 8")
        let values = try io.getArrayOfInt()
        XCTAssertEqual(values, [10, 15, 2, 42, 8])
    }

    func testArrayOfIntMultipleLines() throws {
        var io = Input(" 10  15  2 42 8\n4 30 2 ")
        let line1 = try io.getArrayOfInt()
        XCTAssertEqual(line1, [10, 15, 2, 42, 8])
        let line2 = try io.getArrayOfInt()
        XCTAssertEqual(line2, [4, 30, 2])
    }

    func testArrayOfIntMultipleLinesThrows() throws {
        var io = Input(" 10  15  2 a 42 8\n4 30 2 ")
        do {
            let _ = try io.getArrayOfInt()
            XCTFail("test should have thrown")
        } catch InputError.notInt(_) {

        } catch {
            XCTFail("different error thrown then expected")
        }
    }

    func testArrayOfIntMultipleLinesAsOneArray() throws {
        var io = Input(" 10  15  2 42 8\n4 30 2 ")
        let line1 = try io.getArrayOfInt(until: nil)
        XCTAssertEqual(line1, [10, 15, 2, 42, 8, 4, 30, 2])
    }

    func testArrayOfDoubleAsInt() throws {
        var io = Input(" 10  15  2 42 8")
        let values = try io.getArrayOfDouble()
        XCTAssertEqual(values, [10.0, 15.0, 2.0, 42.0, 8.0])
    }

    func testArrayOfDouble() throws {
        var io = Input(" 10.5  15.25  2.0 42.125 8")
        let values = try io.getArrayOfDouble()
        XCTAssertEqual(values, [10.5, 15.25, 2.0, 42.125, 8.0])
    }

    func testArrayOfDoubleMultipleLines() throws {
        var io = Input(" 10.5  15.25  2.0 42.125 8\n4.5")
        let line1 = try io.getArrayOfDouble()
        XCTAssertEqual(line1, [10.5, 15.25, 2.0, 42.125, 8.0])
        let line2 = try io.getArrayOfDouble()
        XCTAssertEqual(line2, [4.5])
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
