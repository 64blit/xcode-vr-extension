import XCTest
@testable import RepoVerseShared

final class FileSystemScannerTests: XCTestCase {

    var tempDirectory: URL!
    var scanner: FileSystemScanner!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Create a temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        scanner = FileSystemScanner()
    }

    override func tearDownWithError() throws {
        // Clean up temporary directory
        if let tempDirectory = tempDirectory {
            try FileManager.default.removeItem(at: tempDirectory)
        }
        scanner = nil
        try super.tearDownWithError()
    }

    func testScanEmptyDirectory() throws {
        let node = try scanner.scan(directory: tempDirectory)
        XCTAssertEqual(node.name, tempDirectory.lastPathComponent)
        XCTAssertEqual(node.type, .folder)
        XCTAssertEqual(node.children?.count ?? 0, 0)
        XCTAssertEqual(node.metadata?.loc ?? 0, 0)
    }

    func testScanSingleFile() throws {
        let fileName = "test.swift"
        let content = "line 1\nline 2\nline 3"
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        try content.write(to: fileURL, atomically: true, encoding: .utf8)

        let node = try scanner.scan(directory: tempDirectory)
        XCTAssertEqual(node.children?.count ?? 0, 1)

        let child = node.children?.first
        XCTAssertEqual(child?.name, fileName)
        XCTAssertEqual(child?.type, .file)
        XCTAssertEqual(child?.metadata?.loc, 3)
        XCTAssertEqual(node.metadata?.loc, 3) // Directory LOC should sum children
    }

    func testScanNestedDirectories() throws {
        // Structure:
        // root/
        //   folder1/
        //     file1.swift (2 lines)
        //   file2.swift (4 lines)

        let folder1 = tempDirectory.appendingPathComponent("folder1")
        try FileManager.default.createDirectory(at: folder1, withIntermediateDirectories: true)

        let file1 = folder1.appendingPathComponent("file1.swift")
        try "line 1\nline 2".write(to: file1, atomically: true, encoding: .utf8)

        let file2 = tempDirectory.appendingPathComponent("file2.swift")
        try "1\n2\n3\n4".write(to: file2, atomically: true, encoding: .utf8)

        let node = try scanner.scan(directory: tempDirectory)

        XCTAssertEqual(node.children?.count, 2)
        XCTAssertEqual(node.metadata?.loc, 6) // 2 + 4

        // Check sorting: file2 vs folder1
        // Scanner sorts folders before files.
        // So folder1 should be first, then file2.swift

        let firstChild = node.children?[0]
        XCTAssertEqual(firstChild?.name, "folder1")
        XCTAssertEqual(firstChild?.type, .folder)
        XCTAssertEqual(firstChild?.metadata?.loc, 2)

        let secondChild = node.children?[1]
        XCTAssertEqual(secondChild?.name, "file2.swift")
        XCTAssertEqual(secondChild?.type, .file)
        XCTAssertEqual(secondChild?.metadata?.loc, 4)
    }

    func testIgnoreDirectories() throws {
        let gitDir = tempDirectory.appendingPathComponent(".git")
        try FileManager.default.createDirectory(at: gitDir, withIntermediateDirectories: true)

        let node = try scanner.scan(directory: tempDirectory)
        XCTAssertEqual(node.children?.count ?? 0, 0)
    }

    func testIgnoreSymlinks() throws {
        let targetDir = tempDirectory.appendingPathComponent("target")
        try FileManager.default.createDirectory(at: targetDir, withIntermediateDirectories: true)

        let symlink = tempDirectory.appendingPathComponent("link")
        try FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: targetDir)

        let node = try scanner.scan(directory: tempDirectory)

        // Should ignore symlink, so children count 1 (target dir)
        // "target" is a normal directory, so it should be scanned.
        // "link" is a symlink, so it should be skipped.
        // So count is 1.

        XCTAssertEqual(node.children?.count, 1)
        XCTAssertEqual(node.children?.first?.name, "target")
    }
}
