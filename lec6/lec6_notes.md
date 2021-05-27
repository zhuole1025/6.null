# Version Control (git)
Version control systems (VCSs) are tools used to track changes to source code (or other collections of files and folders). As the name implies, these tools help maintain a history of changes; furthermore, they facilitate collaboration. VCSs track changes to a folder and its contents in a series of snapshots, where each snapshot encapsulates the entire state of files/folders within a top-level directory. VCSs also maintain metadata like who created each snapshot, messages associated with each snapshot, and so on.
### Data Model
* Snapshots: the top level tree that is being tracked
    * blob: a bunch of bytes
    * tree: map names to blobs or trees
    ```shell
    <root> (tree)
    |
    +- foo (tree)
    |  |
    |  + bar.txt (blob, contents = "hello world")
    |
    +- baz.txt (blob, contents = "git is wonderful")
    ```
* Modeling history: relating snapshots
    * In Git, a history is a directed acyclic graph (DAG) of snapshots
    * snapshots = commits
    ```shell
    o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
    ```
* Pseudocode of the data model
    ```c++
    // a file is a bunch of bytes
    type blob = array<byte>
    
    // a directory contains named files and directories
    type tree = map<string, tree | blob>
    
    // a commit has parents, metadata, and the top-level tree
    type commit = struct {
        parent: array<commit>
        author: string
        message: string
        snapshot: tree
    }
    ```
* Objects and content-addressing
    * Object: blob, tree, or commit  
      `type object = blob | tree | commit`
    * All objects are content-addressed by their SHA-1 hash  
      ```python
      objects = map<string, object>

      def store(object):
          id = sha1(object)
          objects[id] = object
    
      def load(id):
          return objects[id]
      ```
    * Blobs, trees, and commits are unified in this way: they are all objects. When they reference other objects, they don’t actually contain them in their on-disk representation, but have a reference to them by their hash
    * Use `git cat-file -p {id}` to look inside an object
    * Use `git log --all --graph --decorate` to visualize the DAG
* References
    * References are pointers to commits
    * References are mutable (can be updated to point to a new commit)
    * `master` : point to the latest commit in the main vranch of development
    * `HEAD` : point to where you currently are
      ```python
      references = map<string, string>

      def update_reference(name, id):
          references[name] = id

      def read_reference(name):
          return references[name]

      def load_reference(name_or_id):
          if name_or_id in references:
              return load(references[name_or_id])
          else:
              return load(name_or_id)
      ```
* Repositories
    * Git repository: the data `objects` and `references`
    * All git commands map to some manipulation of the commit DAG by adding objects and adding/updating references

---

### Staging area
Git accommodates allow you to specify which modifications should be included in the next snapshot through a mechanism called the “staging area”

---

### Git command-line interface
* Basics
    * `git help` <command> : get help for a git command
    * `git init` : creates a new git repo, with data stored in the `.git` directory
    * `git status`:  tells you what’s going on
    * `git add <filename>` : adds files to staging area
    * `git commit` : creates a new commit
        * Write [good commit messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
        * Even more reasons to write [good commit messages](https://chris.beams.io/posts/git-commit/)!
    * `git log` : shows a flattened log of history
    * `git log --all --graph --decorate` : visualizes history as a DAG
    * `git diff <filename>` : show changes you made relative to the staging area
    * `git diff <revision> <filename>` : shows differences in a file between snapshots
    * `git checkout <revision>` : updates HEAD and current branch
* Branching and merging
    * `git branch` : shows branches
    * `git branch <name>` : creates a branch
    * `git checkout -b <name>` : creates a branch and switches to it
        * same as `git branch <name>; git checkout <name>`
    * `git merge <revision>` : merges into current branch
    * `git mergetool` : use a fancy tool to help resolve merge conflicts
    * `git rebase` : rebase set of patches onto a new base
* Remotes
    * `git remote` : list remotes
    * `git remote add <name> <url>` : add a remote
    * `git push <remote> <local branch>:<remote branch>` : send objects to remote, and update remote reference
    * `git branch --set-upstream-to=<remote>/<remote branch>` : set up correspondence between local and remote branch
    * `git fetch` : retrieve objects/references from a remote
    * `git pull` : same as `git fetch; git merge`
    * `git clone` : download repository from remote
* Undo
    * `git commit --amend` : edit a commit’s contents/message
    * `git reset HEAD <file>` : unstage a file
    * `git checkout -- <file>` : discard changes
* Advanced Git
    * `git config` : Git is [highly customizable](https://git-scm.com/docs/git-config)
    * `git clone --depth=1` : shallow clone, without entire version history
    * `git add -p` : interactive staging
    * `git rebase -i` : interactive rebasing
    * `git blame` : show who last edited which line
    * `git stash` : temporarily remove modifications to working directory
    * `git bisect` : binary search history (e.g. for regressions)
    * `.gitignore` : [specify](https://git-scm.com/docs/gitignore) intentionally untracked files to ignore

---

### Exercise
1. Finish
2. Finish
    ```shell
    git log --all --graph --decorate
    git log --grep=README
    git blame _config.yml | rg collections: | sed -E 's/^(.{8}).*$/\1/' | xargs git show
    ```
3. Finish
    ```shell
    git filter-branch --force --index-filter \
      "git rm --cached --ignore-unmatch 6-git/ex3.txt" \
        --prune-empty --tag-name-filter cat -- --all
    ```
4. Finish
5. `git config --global alias.graph 'log --all --graph --decorate --oneline'`
6. Finish

