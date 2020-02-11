Title: Git cheatsheet
Published: 10/29/2019
Tags:
    - Git
    - Cheatsheet
---
Update existing commit

    git commit --amend --no-edit
    git push --force 

Remove all local changes

    git clean -fdx

Mirror repositories

    git clone --mirror <source.repository>
    cd source.repository.git
    git push --mirror <target.repository>
	
Update submodules

    git submodule update --init --recursive --progress
	
Remove last commit

    git reset --soft HEAD~1
    git reset --hard HEAD~1
  
Reset file

    git checkout -- <path>

Merge changes as a single commit
    
    git merge --squash <source branch>
    git commit --message "merge commit message"
    
Get remote changes and apply local changes
    
    git stash
    git pull --rebase origin <source branch>
    git stash pop
