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

    git clone --mirror [source.repository]
    cd source.repository.git
    git push --mirror [target.repository]
	
Update submodules

    git submodule update --init --recursive --progress