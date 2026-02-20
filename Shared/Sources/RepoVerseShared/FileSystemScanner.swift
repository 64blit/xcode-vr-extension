import Foundation

public class FileSystemScanner {
    public init() {}

    public func scan(directory: URL) throws -> FileNode {
        let name = directory.lastPathComponent
        let path = directory.path

        var children: [FileNode] = []
        var directoryLoc = 0

        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .nameKey, .isHiddenKey, .isSymbolicLinkKey]

        let fileManager = FileManager.default

        // Get contents of the directory
        // Do not skip hidden files, so we can see configuration files like .gitignore, .github workflows, etc.
        let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: resourceKeys, options: [])

        for url in contents {
            if shouldIgnore(url: url) {
                continue
            }

            let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))

            // Skip symbolic links to avoid infinite recursion
            if let isSymbolicLink = resourceValues.isSymbolicLink, isSymbolicLink {
                continue
            }

            let isDirectory = resourceValues.isDirectory ?? false

            if isDirectory {
                // Recursive call for subdirectories
                let node = try scan(directory: url)
                children.append(node)

                // Add subdirectory's LOC to current directory's total
                if let childLoc = node.metadata?.loc {
                    directoryLoc += childLoc
                }
            } else {
                // Process file
                let loc = calculateLOC(file: url)
                directoryLoc += loc

                let metadata = FileMetadata(loc: loc)
                let node = FileNode(
                    id: url.path, // Use path as stable ID
                    name: url.lastPathComponent,
                    type: .file,
                    path: url.path,
                    children: nil,
                    metadata: metadata
                )
                children.append(node)
            }
        }

        // Sort children: folders first, then files; alphabetically within groups
        children.sort { (node1, node2) -> Bool in
            if node1.type == node2.type {
                return node1.name.localizedStandardCompare(node2.name) == .orderedAscending
            }
            return node1.type == .folder // Folders before files
        }

        let metadata = FileMetadata(loc: directoryLoc)

        return FileNode(
            id: path,
            name: name,
            type: .folder,
            path: path,
            children: children,
            metadata: metadata
        )
    }

    private func shouldIgnore(url: URL) -> Bool {
        let ignoredNames: Set<String> = [
            ".git", ".DS_Store", "node_modules", "build", ".build", ".swiftpm",
            "Pods", "DerivedData", "fastlane", "venv", ".env", "__pycache__"
        ]
        return ignoredNames.contains(url.lastPathComponent)
    }

    private func calculateLOC(file: URL) -> Int {
        // Attempt to read file as UTF-8 string
        guard let data = try? Data(contentsOf: file),
              let content = String(data: data, encoding: .utf8) else {
            return 0
        }

        // Simple LOC count: number of newlines
        // We can improve this by filtering empty lines or comments later if needed
        let lines = content.components(separatedBy: .newlines)
        return lines.count
    }
}
