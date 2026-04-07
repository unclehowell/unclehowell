---
name: datro-library-docs
description: Create documents in DATRO Consortium Document Library format (mandate, brief, plan, highlight, debrief)
version: 1.0.0
author: DATRO Second Brain (AI)
metadata:
  hermes:
    tags: [documentation, datro, library, mandate, brief, plan]
---

# DATRO Library Document Creation

## CRITICAL RULES

1. **NEVER copy content from other documents** - Always write fresh content specific to the project
2. **ALWAYS verify output** - Check what you created matches what was asked
3. **Use index.html with HTML content directly** - Not Sphinx build output
4. **Use tables** - For work packages, tasks, timelines

## Document Structure

### MANDATE
- Purpose: What the client wants
- Background: Current issues
- Objectives: What needs to be achieved
- Constraints: Time, budget, resources
- Quality Expectation: What success looks like

### BRIEF
- Executive Summary
- Proposed Solution
- Work Packages (with table)
- Timeline (with table)
- Deliverables (with table)
- Risks and Mitigation

### PLAN
- Work Packages with specific tasks
- Task dependencies
- Agent assignments
- Progress tracking format
- Success criteria checklist

## File Structure

```
library/consortium_projects/[docname]/
├── index.html          # Menu + content (HTML with theme)
├── _treeview.json      # Navigation
└── 0-0-1/
    └── source/
        ├── index.rst   # RST source
        └── releasenotes.rst
```

## HTML Template for index.html

```html
<!DOCTYPE html>
<html>
  <head>
  <meta charset="UTF-8">
  <meta content="DATRO Library" name="description">
  <meta content="DATRO Consortium" name="author">
  <title>[TITLE]</title>
  <meta content="width=device-width, initial-scale=1" name="viewport">
  <link href="../../_theme-explorer/favicons/apple-icon-57x57.png" rel="apple-touch-icon" sizes="57x57">
  <!-- ... other favicons ... -->
  <link rel="stylesheet" href="../../_theme-explorer/style.css">
  <link rel="stylesheet" href="../../_theme-explorer/glyphicon.css">
  <style>
    .doc-content { padding: 20px; max-width: 900px; margin: 0 auto; }
    .doc-content h1 { color: #1a5f7a; border-bottom: 2px solid #1a5f7a; }
    .doc-content h2 { color: #2c7873; margin-top: 25px; }
    .doc-content table { width: 100%; border-collapse: collapse; margin: 15px 0; }
    .doc-content th, .doc-content td { border: 1px solid #ddd; padding: 8px; }
    .doc-content th { background: #1a5f7a; color: white; }
  </style>
  </head>
  <body>
    <div class="doc-content">
      [YOUR CONTENT HERE]
    </div>
  </body>
</html>
```

## _treeview.json Template

```json
[
  {
    "name": "<div><b class='greenish'>HTML</b>|<b class='redish'>PDF</b></div>",
    "path": "javascript:void(0)",
    "_links": { "html": "javascript:void(0)" }
   },
   {
     "name": "<div class='title-line title-disable'><div class='flag f-gb'></div>English</div>",
     "path": "javascript:void(0)",
     "_links": { "html": "javascript:void(0)" }
    },
   {
     "name": "<div class='language-subtitle-line enable-link gish'>Latest</div>",
     "path": "./index.html",
     "_links": { "html": "./index.html" }
    },
   { "name": "<div class='page-scroll-fix'></div>", "path": "javascript:void(0)", "_links": { "html": "javascript:void(0)" } }
]
```

## Common Mistakes to Avoid

1. **DON'T use Sphinx build output** - Put content directly in index.html
2. **DON'T copy content from other docs** - Write fresh content
3. **DO verify against what client asked** - Before presenting
4. **DO use tables** - For work packages, tasks, timelines

## Workflow

1. Create directory structure
2. Write index.html with HTML content (not Sphinx)
3. Create _treeview.json for navigation
4. Update parent _treeview.json to include new document
5. Verify in browser

## Remember
- Content must be specific to the project
- Use tables for breakdowns
- Apply DATRO theme CSS
- Always verify before presenting
