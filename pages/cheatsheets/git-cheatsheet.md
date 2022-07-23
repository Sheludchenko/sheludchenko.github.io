---
date: 2022-07-23
title: Git
layout: default
tags:
  - git
  - cheatsheet
  - basics
icon: git-compare
---
Remove all ignored files and folders

```bash
git clean -n -fdX
git clean -fdX
```

Update existing commit

```bash
git commit --amend --no-edit
git push --force 
```

Remove all local changes

```bash
git clean -fdx
git checkout -- .
```

Mirror repositories

```bash
git clone --mirror <source.repository>
cd source.repository.git
git push --mirror <target.repository>
```

Update submodules

```bash
git submodule update --init --recursive --progress
```

Remove last commit

```bash
git reset --soft HEAD~1
git reset --hard HEAD~1
```

Reset file

```bash
git checkout -- <path>
```

Merge changes as a single commit

```bash
git merge --squash <source branch>
git commit --message "merge commit message"
```

Get remote changes and apply local changes

```bash
git stash
git pull --rebase origin <source branch>
git stash pop
```

Rebase root commit

```bash
git rebase --root
```