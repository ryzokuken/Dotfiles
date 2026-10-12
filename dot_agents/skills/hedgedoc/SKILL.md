---
name: hedgedoc
description: Import a HedgeDoc note from notes.igalia.com into the Logseq graph as a snapshot in pages/.
argument-hint: <note URL>
disable-model-invocation: true
---

Import a HedgeDoc note from notes.igalia.com into the Logseq graph as a snapshot in pages/.

The URL to import is: $ARGUMENTS

Follow these steps exactly:

## Step 1: Parse the URL

Take the URL and:
- Strip any `#anchor` fragment (everything after `#`)
- Strip any `?query` parameters (everything after `?`)
- If the path matches `/p/<id>` (published view), rewrite to use `/<id>` as the path
- Append `/raw` to the end of the path to get the fetch URL

Examples:
- `https://notes.igalia.com/Cfagr88DTGy5ltsd1JQwXw` → `https://notes.igalia.com/Cfagr88DTGy5ltsd1JQwXw/raw`
- `https://notes.igalia.com/cross-team-communications#section` → `https://notes.igalia.com/cross-team-communications/raw`
- `https://notes.igalia.com/p/2MUpJraYd` → `https://notes.igalia.com/2MUpJraYd/raw`
- `https://notes.igalia.com/MoonforgePressRelease?both` → `https://notes.igalia.com/MoonforgePressRelease/raw`

## Step 2: Fetch the note via browser

1. Create a new Chrome tab using `mcp__claude-in-chrome__tabs_create_mcp`
2. Navigate to the `/raw` URL using `mcp__claude-in-chrome__navigate`
3. Wait briefly for the page to load, then use `mcp__claude-in-chrome__get_page_text` to read the content

If the resulting page text looks like a login page or SSO redirect (not raw markdown), stop and tell the user: "Your notes.igalia.com session appears to have expired. Please log in at notes.igalia.com in Chrome, then try again." Then close the tab and stop.

## Step 3: Extract title and derive filename

From the raw markdown content:
- Find the first line starting with `# ` — strip the `# ` prefix to get the title
- If no H1 exists, use the URL slug (the last path segment before `/raw`) as the title

Derive the Logseq page filename:
- Replace any `/` characters with `%2F` (Logseq namespace encoding)
- Replace characters that are invalid in filenames (`:`, `*`, `?`, `"`, `<`, `>`, `|`, `\`) with `-`
- Keep the `.md` extension

## Step 4: Check for existing file

Check if `/home/ryzo/Main Folder/LNotes/pages/<filename>.md` already exists using the Read tool.
If it exists, ask the user whether to overwrite before writing.

## Step 5: Write the file

Write the raw markdown content to `/home/ryzo/Main Folder/LNotes/pages/<filename>.md`.

## Step 6: Close the tab and report

Close the Chrome tab using `mcp__claude-in-chrome__javascript_tool` with `window.close()`.

Report to the user:
- The page title
- The file path written
- A reminder that Logseq will index it automatically on next sync/refresh
