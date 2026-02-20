import Foundation

public struct FileNode: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let type: NodeType
    public let path: String
    public var children: [FileNode]?
    public var metadata: FileMetadata?

    public init(id: String, name: String, type: NodeType, path: String, children: [FileNode]? = nil, metadata: FileMetadata? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.path = path
        self.children = children
        self.metadata = metadata
    }
}

public enum NodeType: String, Codable, Hashable {
    case file
    case folder
}

public struct FileMetadata: Codable, Hashable {
    public let summary: String?
    public let loc: Int?
    public let dependencies: [String]? // IDs of other nodes

    public init(summary: String? = nil, loc: Int? = nil, dependencies: [String]? = nil) {
        self.summary = summary
        self.loc = loc
        self.dependencies = dependencies
    }
}
