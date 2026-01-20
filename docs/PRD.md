# Product Requirements Document: RepoVerse (Xcode 3D Visualizer)

## 1. Introduction
RepoVerse is an Xcode extension (implemented as a companion macOS application) that visualizes software repositories as an interactive 3D scene. By leveraging Three.js and VR technologies, it transforms flat file structures into a navigable node graph, allowing developers to understand architecture, dependencies, and code context through spatial exploration.

## 2. Objectives
- **Enhance Architectural Understanding**: Provide a high-level visual overview of project structure.
- **Contextual Discovery**: Use AI to provide on-demand summaries and architectural insights.
- **Dependency Tracking**: Visualize how files and modules interact.
- **Immersive Navigation**: Allow users to explore codebases using 3D and VR controls.

## 3. Key Features

### 3.1 Repository Visualization
- **3D Tree Structure**: Represent folders and files as nodes in 3D space.
  - **Folders**: Container nodes that can expand/collapse.
  - **Files**: Leaf nodes representing source code.
- **File System Traversal**: Recursively read the repository starting from a root directory.
- **Filtering**: Respect `.gitignore` to exclude irrelevant files.

### 3.2 Interactive Navigation
- **Controls**: Orbit, Pan, and Zoom controls to navigate the 3D space.
- **Drill-down**: Click or zoom into nodes to reveal deeper details.
- **VR Support**: Toggle VR mode to view the graph via WebXR compatible devices (or simulated 3D view).

### 3.3 AI-Enhanced Metadata
- **Node Summaries**: Display AI-generated descriptions for folders and files (e.g., "Authentication Module").
- **Architectural Tooltips**: Hovering over a file node reveals function layouts and purpose summaries.
- **Context Awareness**: Summaries are generated based on file content and comments.

### 3.4 Dependency Mapping
- **Relationship Lines**: Draw lines between nodes to represent:
  - Imports/Includes.
  - Class Instantiations.
  - Inheritance.
- **Filters**: Toggle visibility of specific dependency types (e.g., "Show only Import lines").

## 4. Technical Requirements

### 4.1 Platform & Tech Stack
- **Native Container**: macOS Application (Swift/SwiftUI).
- **Extension Interface**: Xcode Source Editor Extension (to launch the app with context).
- **Visualization Engine**: Three.js (JavaScript/WebGL) running in `WKWebView`.
- **Data Bridge**: Communication between Swift (File System) and JavaScript (Visualization) via `WKScriptMessageHandler`.
- **AI Service**: Integration with an LLM API (e.g., OpenAI) for metadata generation.

### 4.2 Performance
- **Large Repositories**: Support repositories with thousands of files using instanced rendering or level-of-detail (LOD) techniques.
- **Asynchronous Loading**: Load file structure and metadata asynchronously to prevent UI freezing.

## 5. User Stories
1. **As a new developer**, I want to see the entire project structure in 3D so I can understand where core modules are located.
2. **As an architect**, I want to visualize dependencies between modules to identify tight coupling.
3. **As a reviewer**, I want to hover over a file node to read an AI summary of its purpose without opening the code.
4. **As a VR enthusiast**, I want to "fly" through the codebase to explore the architecture spatially.

## 6. UI/UX Guidelines
- **Visual Style**: Cyberpunk/Sci-Fi aesthetic for the node graph.
- **Color Coding**: distinct colors for different file types (e.g., Blue for Swift, Yellow for JS, Grey for Config).
- **Responsiveness**: Smooth 60fps rendering in the WebView.
