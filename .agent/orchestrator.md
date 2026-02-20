# RepoVerse Orchestrator

This document tracks the iterative implementation of RepoVerse features.

## Workflow
1.  **Architecture & Setup** (Current Phase): Project structure, documentation, and base configuration.
2.  **Implementation**: Each feature is implemented in a separate PR, following the order below.
3.  **Verification**: Each PR must include tests or verification steps.

## Feature Roadmap

### Phase 1: Foundation
- [ ] **Feature 1: Basic Web Visualization**
    -   Setup Three.js scene with a simple spinning cube.
    -   Implement Vite build pipeline to output to `App/Resources/dist`.
    -   Verify the output can be loaded in a browser.

- [ ] **Feature 2: Swift App Shell & WebView Bridge**
    -   Create the basic macOS App structure.
    -   Implement `WebViewContainer` (SwiftUI) wrapping `WKWebView`.
    -   Load the `index.html` from the bundle.
    -   Implement basic `JS <-> Swift` communication (logging).

### Phase 2: Core Visualization
- [ ] **Feature 3: File System Service**
    -   Implement `FileSystemService` to traverse a directory.
    -   Generate `FileNode` tree structure.
    -   Handle `.gitignore`.

- [ ] **Feature 4: 3D Graph Generation**
    -   Pass `FileNode` JSON to the WebView.
    -   Implement `GraphBuilder` in Three.js to visualize the tree (e.g., Force Directed Graph or Directory Tree).
    -   Implement OrbitControls.

### Phase 3: Advanced Features
- [ ] **Feature 5: Interaction & Selection**
    -   Implement raycasting for node selection.
    -   Send selection events to Swift.
    -   Display file details in a SwiftUI side panel.

- [ ] **Feature 6: AI Metadata Integration**
    -   Implement `AIService` (OpenAI API).
    -   Generate summaries for selected nodes.
    -   Display summaries in tooltips.

- [ ] **Feature 7: Xcode Extension**
    -   Implement the Source Editor Extension command.
    -   Launch the main app with the current file path.

## Status Log
-   **[Date]**: Initial Setup started.
