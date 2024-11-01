#!/bin/bash

# Get the current wallpaper path
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")

# Get the dominant color
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extract RGB values
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calculate inverse colors
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Improved contrast calculation
calculate_contrast() {
    local bg_r=$1
    local bg_g=$2
    local bg_b=$3
    
    # Calculate relative luminance for background
    local bg_luminance=$(( (bg_r*299 + bg_g*587 + bg_b*114) / 1000 ))
    
    # Calculate text color with better contrast
    if [ $bg_luminance -gt 128 ]; then
        # Dark text on light background
        TEXT_R=$(( bg_r * 20 / 100 ))
        TEXT_G=$(( bg_g * 20 / 100 ))
        TEXT_B=$(( bg_b * 20 / 100 ))
    else
        # Light text on dark background
        TEXT_R=$(( bg_r * 200 / 100 ))
        TEXT_G=$(( bg_g * 200 / 100 ))
        TEXT_B=$(( bg_b * 200 / 100 ))
    fi
}

# Calculate contrast based on background color
calculate_contrast $R $G $B

# Clamp RGB values
clamp() {
    echo $(( $1 > 255 ? 255 : $1 < 0 ? 0 : $1 ))
}

TEXT_R=$(clamp $TEXT_R)
TEXT_G=$(clamp $TEXT_G)
TEXT_B=$(clamp $TEXT_B)

# Calculate accent colors
ACCENT_R=$(( (R + 64) % 256 ))
ACCENT_G=$(( (G + 128) % 256 ))
ACCENT_B=$(( (B + 192) % 256 ))

# Calculate secondary colors
SEC_R=$(( (R + INV_R) / 2 ))
SEC_G=$(( (G + INV_G) / 2 ))
SEC_B=$(( (B + INV_B) / 2 ))

# Generate VS Code custom CSS
cat <<EOF > "$HOME/.vscode/custom.css"
/* VS Code Dynamic Colors - Comprehensive Theme */
body {
    --vscode-editor-background: rgba($R, $G, $B, 1) !important;
    --vscode-editor-foreground: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
    --vscode-sideBar-background: rgba($R, $G, $B, 0.9) !important;
    --vscode-sideBar-foreground: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
    --vscode-activityBar-background: rgba($R, $G, $B, 0.95) !important;
    --vscode-activityBar-foreground: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Main workbench */
.monaco-workbench {
    background-color: rgba($R, $G, $B, 1) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Editor */
.monaco-editor,
.monaco-editor .margin,
.monaco-editor-background,
.monaco-editor .inputarea.ime-input {
    background-color: rgba($R, $G, $B, 1) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* File Explorer and Sidebar */
.monaco-workbench .part.sidebar,
.monaco-workbench .sidebar .tree-explorer-viewlet-tree-view,
.monaco-workbench .sidebar .monaco-list,
.monaco-workbench .sidebar .monaco-list-row,
.monaco-pane-view,
.split-view-view,
.explorer-folders-view,
.monaco-tl-row {
    background-color: rgba($R, $G, $B, 0.9) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Activity Bar */
.monaco-workbench .part.activitybar,
.monaco-workbench .activitybar > .content .monaco-action-bar .action-item,
.monaco-workbench .activitybar > .content :not(.monaco-menu) > .monaco-action-bar .action-item {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Title Bar */
.monaco-workbench .part.titlebar,
.monaco-workbench .title,
.monaco-workbench > .titlebar,
.window-title {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Status Bar */
.monaco-workbench .part.statusbar,
.monaco-workbench .statusbar > .statusbar-item {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Tabs */
.monaco-workbench .part.editor > .content .editor-group-container > .title .tabs-container > .tab,
.monaco-workbench .part.editor > .content .editor-group-container > .title .tabs-container > .tab .tab-label {
    background-color: rgba($R, $G, $B, 0.6) !important;
    color: rgba($TEXT_R, $TEXT_G, $TEXT_B, 0.7) !important;
}

.monaco-workbench .part.editor > .content .editor-group-container > .title .tabs-container > .tab.active,
.monaco-workbench .part.editor > .content .editor-group-container > .title .tabs-container > .tab.active .tab-label {
    background-color: rgba($SEC_R, $SEC_G, $SEC_B, 0.3) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Lists and Trees */
.monaco-list,
.monaco-list-row,
.monaco-tree,
.monaco-tree-row,
.tree-explorer-viewlet-tree-view {
    background-color: transparent !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

.monaco-list.list_id_1 .monaco-list-row.focused,
.monaco-list .monaco-list-row.selected,
.monaco-list .monaco-list-row.focused {
    background-color: rgba($ACCENT_R, $ACCENT_G, $ACCENT_B, 0.3) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Input and Search boxes */
.monaco-inputbox,
.monaco-workbench .part.editor > .content .editor-group-container > .title .monaco-icon-label-container,
.search-view .search-widget .input-box,
.monaco-workbench .search-editor .search-widget .input-box,
.monaco-workbench .search-editor .search-widget .replace-input {
    background-color: rgba($SEC_R, $SEC_G, $SEC_B, 0.2) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Quick Input */
.quick-input-widget,
.monaco-quick-input-widget {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Notifications */
.monaco-workbench .notifications-list-container,
.monaco-workbench .notification-toast-container {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Dropdown menus */
.monaco-dropdown,
.monaco-dropdown-box,
.context-view.monaco-menu-container,
.monaco-dropdown-with-primary {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Scrollbars */
.monaco-scrollable-element > .scrollbar > .slider {
    background: rgba($SEC_R, $SEC_G, $SEC_B, 0.4) !important;
}

/* Editor widgets (suggestions, parameter hints, etc.) */
.monaco-editor .suggest-widget,
.monaco-editor .parameter-hints-widget,
.monaco-editor .peek-view-widget,
.monaco-editor .monaco-hover,
.monaco-editor .glyph-margin,
.monaco-editor .codicon {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Selection and highlights */
.monaco-editor .selected-text,
.monaco-editor .selectionHighlight {
    background-color: rgba($ACCENT_R, $ACCENT_G, $ACCENT_B, 0.3) !important;
}

/* Line numbers and current line */
.monaco-editor .line-numbers,
.monaco-editor .line-numbers.active-line-number {
    color: rgba($TEXT_R, $TEXT_G, $TEXT_B, 0.5) !important;
}

.monaco-editor .current-line,
.monaco-editor .view-overlays.focused .current-line {
    background-color: rgba($SEC_R, $SEC_G, $SEC_B, 0.1) !important;
}

/* Breadcrumbs */
.monaco-workbench .part.editor > .content .editor-group-container > .title .breadcrumbs-control {
    background-color: transparent !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Panel (terminal, output, etc.) */
.monaco-workbench .part.panel,
.monaco-workbench .part.panel > .content,
.panel-background {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Icons */
.codicon,
.monaco-workbench .codicon,
.monaco-action-bar .action-item .codicon {
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Activity Bar badges */
.monaco-workbench .activitybar > .content .monaco-action-bar .badge {
    background-color: rgb($ACCENT_R, $ACCENT_G, $ACCENT_B) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Settings editor */
.monaco-workbench .settings-editor > .settings-body > .settings-tree-container .setting-item-contents,
.monaco-workbench .settings-editor > .settings-body .settings-tree-container .setting-item-bool .setting-value-checkbox {
    background-color: transparent !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Additional selectors for Explorer, Outline, and Timeline */
.monaco-workbench .part.sidebar .composite.title,
.monaco-workbench .part.sidebar .title,
.monaco-workbench .part.sidebar .pane-header,
.monaco-workbench .auxiliary-bar-title,
.monaco-workbench .composite.title {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Section headers (EXPLORER, OUTLINE, etc.) */
.monaco-workbench .part.sidebar .title-label h2,
.monaco-workbench .part.sidebar .title-label h3,
.monaco-workbench .auxiliary-bar-title h2,
.monaco-workbench .composite.title h2 {
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Tree view improvements */
.monaco-workbench .part.sidebar .tree-explorer-viewlet-tree-view,
.monaco-workbench .part.sidebar .monaco-list-row,
.monaco-workbench .part.sidebar .monaco-tl-row,
.monaco-workbench .part.sidebar .monaco-tl-contents,
.monaco-workbench .part.sidebar .monaco-tl-twistie,
.monaco-workbench .part.sidebar .monaco-icon-label,
.monaco-workbench .part.sidebar .monaco-icon-label-container,
.monaco-workbench .part.sidebar .monaco-icon-name-container,
.monaco-workbench .part.sidebar .label-name,
.monaco-workbench .part.sidebar .label-description {
    background-color: transparent !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Hover states for tree items */
.monaco-workbench .part.sidebar .monaco-list-row:hover:not(.selected):not(.focused),
.monaco-workbench .part.sidebar .monaco-tl-row:hover:not(.selected):not(.focused) {
    background-color: rgba($SEC_R, $SEC_G, $SEC_B, 0.3) !important;
}

/* Selected and focused states */
.monaco-workbench .part.sidebar .monaco-list.focused .selected,
.monaco-workbench .part.sidebar .monaco-list .selected,
.monaco-workbench .part.sidebar .monaco-tl-row.selected {
    background-color: rgba($ACCENT_R, $ACCENT_G, $ACCENT_B, 0.3) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Outline view specific styles */
.outline-tree,
.outline-item,
.monaco-workbench .part.sidebar .outline-element {
    background-color: transparent !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Timeline view specific styles */
.timeline-tree-view,
.timeline-item,
.monaco-workbench .part.sidebar .timeline-element {
    background-color: transparent !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Section expand/collapse arrows */
.monaco-workbench .part.sidebar .twisties,
.monaco-workbench .part.sidebar .monaco-tl-twistie {
    color: rgb($TEXT_R, $TEXT_G, 

 $TEXT_B) !important;
}

/* Additional icon colors */
.monaco-workbench .part.sidebar .monaco-icon-label::before,
.monaco-workbench .part.sidebar .monaco-tl-icon::before,
.monaco-workbench .part.sidebar .folder-icon::before,
.monaco-workbench .part.sidebar .file-icon::before {
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}

/* Ensure all view headers are themed */
.monaco-workbench .part > .title,
.monaco-workbench .part > .content > .composite.title,
.monaco-workbench .part > .content > .composite > .title {
    background-color: rgba($R, $G, $B, 0.95) !important;
    color: rgb($TEXT_R, $TEXT_G, $TEXT_B) !important;
}
EOF

echo "VS Code colors updated successfully!"

