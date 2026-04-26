# Graph Report - .  (2026-04-26)

## Corpus Check
- Corpus is ~1,170 words - fits in a single context window. You may not need a graph.

## Summary
- 36 nodes · 24 edges · 18 communities detected
- Extraction: 79% EXTRACTED · 21% INFERRED · 0% AMBIGUOUS · INFERRED: 5 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Module System|Module System]]
- [[_COMMUNITY_Module System|Module System]]
- [[_COMMUNITY_Theme FFI|Theme FFI]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]
- [[_COMMUNITY_Database Tables|Database Tables]]
- [[_COMMUNITY_Database Tables|Database Tables]]
- [[_COMMUNITY_Theme FFI|Theme FFI]]
- [[_COMMUNITY_Database Tables|Database Tables]]
- [[_COMMUNITY_Database Tables|Database Tables]]
- [[_COMMUNITY_Database Tables|Database Tables]]
- [[_COMMUNITY_Database Tables|Database Tables]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]
- [[_COMMUNITY_Tiny Helper|Tiny Helper]]

## God Nodes (most connected - your core abstractions)
1. `Queuing System` - 13 edges
2. `Wisp HTTP Server` - 3 edges
3. `Client Module` - 3 edges
4. `Lustre Framework` - 2 edges
5. `Settings Feature` - 2 edges
6. `RESTful API` - 2 edges
7. `Customizable Themes` - 2 edges
8. `Server Module` - 2 edges
9. `Shared Module` - 2 edges
10. `Gleam Language` - 1 edges

## Surprising Connections (you probably didn't know these)
- `Shared Module` --conceptually_related_to--> `Client Module`  [INFERRED]
  shared/README.md → client/README.md
- `Lustre Framework` --conceptually_related_to--> `Client Module`  [INFERRED]
  README.md → client/README.md
- `Wisp HTTP Server` --conceptually_related_to--> `Server Module`  [INFERRED]
  README.md → server/README.md
- `HTML Entry Point` --conceptually_related_to--> `Client Module`  [INFERRED]
  server/priv/index.html → client/README.md
- `Shared Module` --conceptually_related_to--> `Server Module`  [INFERRED]
  shared/README.md → server/README.md

## Hyperedges (group relationships)
- **Technology Stack Components** — readme_gleam, readme_lustre, readme_wisp, readme_mist, readme_pog, readme_postgresql [EXTRACTED 1.00]
- **Database Schema Tables** — readme_terminal_table, readme_queue_table, readme_quetype_table, readme_priority_table, readme_settings_table, readme_themes_table, readme_display_terminal_table, readme_frontdesk_table [EXTRACTED 1.00]
- **Client Feature Views** — readme_terminal, readme_frontdesk, readme_display, readme_settings [EXTRACTED 1.00]

## Communities

### Community 0 - "Community 0"
Cohesion: 0.22
Nodes (9): Display Feature, Frontdesk Feature, Gleam Language, Mist HTTP Adapter, Pog PostgreSQL Driver, PostgreSQL Database, Queuing System, Real-time Queue Management (+1 more)

### Community 1 - "Module System"
Cohesion: 0.5
Nodes (4): RESTful API, Server Module, Shared Module, Wisp HTTP Server

### Community 2 - "Module System"
Cohesion: 0.67
Nodes (3): Client Module, HTML Entry Point, Lustre Framework

### Community 3 - "Theme FFI"
Cohesion: 1.0
Nodes (0): 

### Community 4 - "Tiny Helper"
Cohesion: 1.0
Nodes (0): 

### Community 5 - "Database Tables"
Cohesion: 1.0
Nodes (2): Queue Database Table, Terminal Database Table

### Community 6 - "Database Tables"
Cohesion: 1.0
Nodes (2): Settings Feature, Settings Database Table

### Community 7 - "Theme FFI"
Cohesion: 1.0
Nodes (2): Customizable Themes, Themes Database Table

### Community 8 - "Database Tables"
Cohesion: 1.0
Nodes (1): Quetype Database Table

### Community 9 - "Database Tables"
Cohesion: 1.0
Nodes (1): Priority Database Table

### Community 10 - "Database Tables"
Cohesion: 1.0
Nodes (1): Display Terminal Database Table

### Community 11 - "Database Tables"
Cohesion: 1.0
Nodes (1): Frontdesk Database Table

### Community 12 - "Tiny Helper"
Cohesion: 1.0
Nodes (1): Storail Storage Library

### Community 13 - "Tiny Helper"
Cohesion: 1.0
Nodes (1): Envoy Library

### Community 14 - "Tiny Helper"
Cohesion: 1.0
Nodes (1): Simplifile Library

### Community 15 - "Tiny Helper"
Cohesion: 1.0
Nodes (1): Gleam Standard Library

### Community 16 - "Tiny Helper"
Cohesion: 1.0
Nodes (1): Gleam JSON Library

### Community 17 - "Tiny Helper"
Cohesion: 1.0
Nodes (1): Gleam HTTP Library

## Knowledge Gaps
- **23 isolated node(s):** `Gleam Language`, `Mist HTTP Adapter`, `PostgreSQL Database`, `Pog PostgreSQL Driver`, `Terminal Feature` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Theme FFI`** (2 nodes): `theme_ffi.ffi.js`, `set_css_var()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (2 nodes): `window_ffi.ffi.js`, `is_mobile()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database Tables`** (2 nodes): `Queue Database Table`, `Terminal Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database Tables`** (2 nodes): `Settings Feature`, `Settings Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Theme FFI`** (2 nodes): `Customizable Themes`, `Themes Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database Tables`** (1 nodes): `Quetype Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database Tables`** (1 nodes): `Priority Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database Tables`** (1 nodes): `Display Terminal Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Database Tables`** (1 nodes): `Frontdesk Database Table`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (1 nodes): `Storail Storage Library`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (1 nodes): `Envoy Library`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (1 nodes): `Simplifile Library`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (1 nodes): `Gleam Standard Library`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (1 nodes): `Gleam JSON Library`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Tiny Helper`** (1 nodes): `Gleam HTTP Library`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Queuing System` connect `Community 0` to `Module System`, `Module System`, `Database Tables`, `Theme FFI`?**
  _High betweenness centrality (0.258) - this node is a cross-community bridge._
- **Why does `Lustre Framework` connect `Module System` to `Community 0`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **Why does `Client Module` connect `Module System` to `Module System`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `Client Module` (e.g. with `Lustre Framework` and `Shared Module`) actually correct?**
  _`Client Module` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Gleam Language`, `Mist HTTP Adapter`, `PostgreSQL Database` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._