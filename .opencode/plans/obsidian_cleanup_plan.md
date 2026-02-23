# Plan for Obsidian Vault Cleanup

## Goal
Fix image links for GitHub compatibility and correct grammar in `Docker (Curso).md`.

## Phase 1: Fix Image Links Globally
**Objective:** Convert Obsidian Wiki-links `![[image.png]]` to standard Markdown relative links `![](../path/to/image.png)` for GitHub compatibility.

**Steps:**
1.  **Locate Images:** Identify all images in `vault/Courses/images` and `vault/Concepto/images`.
2.  **Scan Markdown Files:** Iterate through all `.md` files in the `vault` directory.
3.  **Update Links:**
    -   Find `![[filename.png]]` patterns.
    -   Resolve the absolute path of `filename.png`.
    -   Calculate the relative path from the markdown file to the image.
    -   Replace with `![filename.png](relative/path/to/filename.png)`.
    -   Ensure spaces in paths are URL-encoded (`%20`).
4.  **Verification:** Check a few key files to ensure links are correctly formatted.

## Phase 2: Grammar Correction (Demo)
**Objective:** Correct drafting errors in `vault/Courses/Docker (Curso).md` as a demonstration.

**Steps:**
1.  **Read File:** Load the content of `vault/Courses/Docker (Curso).md`.
2.  **Analyze Text:** Identify spelling mistakes (e.g., "reopsitorios"), punctuation errors, and awkward phrasing.
3.  **Apply Corrections:** Use the `edit` tool to apply fixes while preserving the original meaning and technical terms.

## Phase 3: Final Verification
1.  Verify that `Docker (Curso).md` has improved grammar.
2.  Verify that image links in `Docker (Curso).md` and other files are valid relative paths.
