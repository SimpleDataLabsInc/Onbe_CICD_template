# Alternate branching strategies

. . . based on Git Flow.


#### Git Flow (simplified)

``` mermaid
---
config:
  gitGraph:
    parallelCommits: false
    showCommitLabel: false
---
gitGraph TB:
    commit tag: "my_project/0.4.0"
    branch dev order:1
    branch feature-3 order:2
    commit
    commit
    commit
    branch feature-5 order:4
    commit
    commit
    switch dev
    merge feature-3 tag: "my_project/0.4.1-dev"
    switch main
    branch feature-4 order:3
    commit
    switch dev
    merge feature-5 tag: "my_project/0.4.2-dev"
    commit type: HIGHLIGHT id: "PR #5"
    switch feature-4
    commit
    commit
    switch main
    merge dev tag: "my_project/0.5.0"
    %% branch "dev'" order:1
    %% switch "dev'"
    switch dev
    merge main
    %% switch dev
    %% merge "dev'"
    branch feature-6 order:5
    commit
    commit
    commit id: "PR #7"
    switch dev
    merge feature-4 tag: "my_project/0.5.1-dev"
    merge feature-6 tag: "my_project/0.5.2-dev"
    commit type: HIGHLIGHT id: "PR #6"
    switch main
    merge dev tag: "my_project/0.6.0"
```

#### Git Flow (simplified, protect `dev`)

``` mermaid
---
config:
  gitGraph:
    parallelCommits: false
    showCommitLabel: false
---
gitGraph TB:
    commit tag: "my_project/0.9.0"
    branch dev order:1
    branch feature-8 order:3
    commit
    commit
    commit
    branch feature-7 order:2
    commit
    commit
    switch feature-7
    commit type: HIGHLIGHT id: "PR #11"
    switch dev
    merge feature-7 tag: "my_project/0.9.1-dev"
    branch feature-10 order:5
    switch main
    branch feature-9 order:3
    commit
    switch feature-9
    commit type:HIGHLIGHT id: "PR #12"
    switch dev
    merge feature-9 tag: "my_project/0.9.2-dev"
    commit type: HIGHLIGHT id: "PR #13"
    switch feature-8
    commit
    commit
    switch main
    merge dev tag: "my_project/0.10.0"
    switch dev
    merge main
    switch feature-10
    commit
    commit
    switch feature-8
    commit type: HIGHLIGHT id: "PR #14"
    switch feature-10
    commit type: HIGHLIGHT id: "PR #15"
    switch dev
    merge feature-8 tag: "my_project/0.10.1-dev"
    merge feature-10 tag: "my_project/0.10.2-dev"
    commit type: HIGHLIGHT id: "PR #16"
    switch main
    merge dev tag: "my_project/0.11.0"
```

