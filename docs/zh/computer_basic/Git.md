# Git

## 参考

https://liaoxuefeng.com/books/git/what-is-git/svn-vs-git/index.html

https://www.runoob.com/git/git-tutorial.html

## Git是什么

**Git是分布式版本控制系统**

版本控制系统分为两种

- 集中式版本控制
  - 维护一个中央服务器，所有版本库存放在中央服务器，用户想获取版本，需要从中央服务器获取，更改后再将版本更新到中央服务器
  - 例如SVN
- 分布式版本控制
  - 每个用户维护一个完整的版本库，用户之间通过相互推送更新版本（为了方便，Git拥有中央服务器，方便用户之间交换推送）
  - 例如Git

## 暂存区、工作区和版本库的关系

![img](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/Git.assets/1352126739_7909.jpg)

- 图中左侧为工作区，右侧为版本库。在版本库中标记为 "index" 的区域是暂存区（stage/index），标记为 "master" 的是 master 分支所代表的目录树。
- 图中我们可以看出此时 "HEAD" 实际是指向 master 分支的一个"游标"。所以图示的命令中出现 HEAD 的地方可以用 master 来替换。
- 图中的 objects 标识的区域为 Git 的对象库，实际位于 ".git/objects" 目录下，里面包含了创建的各种对象及内容。
- 当对工作区修改（或新增）的文件执行 **git add** 命令时，暂存区的目录树被更新，同时工作区修改（或新增）的文件内容被写入到对象库中的一个新的对象中，而该对象的ID被记录在暂存区的文件索引中。
- 当执行提交操作（git commit）时，暂存区的目录树写到版本库（对象库）中，master 分支会做相应的更新。即 master 指向的目录树就是提交时暂存区的目录树。
- 当执行 **git reset HEAD** 命令时，暂存区的目录树会被重写，被 master 分支指向的目录树所替换，但是工作区不受影响。
- 当执行 **git rm --cached <file>** 命令时，会直接从暂存区删除文件，工作区则不做出改变。
- 当执行 **git checkout .** 或者 **git checkout -- <file>** 命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，会清除工作区中未添加到暂存区中的改动。
- 当执行 **git checkout HEAD .** 或者 **git checkout HEAD <file>** 命令时，会用 HEAD 指向的 master 分支中的全部或者部分文件替换暂存区和以及工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交的改动，也会清除暂存区中未提交的改动。

## 基本操作

### git init/git add/git commit

目录就是工作区

版本库就是工作区中的`.ssh`文件夹

版本库中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支`master`，以及指向`master`的一个指针叫`HEAD`。

```shell
git init #创建版本库

git add <file> #添加文件 
git add . #添加所有文件

git commit -m <message> #提交修改
```

`git add`命令实际上就是把要提交的所有修改放到暂存区（Stage），然后，执行`git commit`就可以一次性把暂存区的所有修改提交到分支。

`git status`显示的就是暂存区的状态



### git diff

提交后，用`git diff HEAD -- readme.txt`命令可以查看工作区和版本库里面最新版本的区别

git diff 有两个主要的应用场景。

- 尚未缓存的改动：**git diff**
- 查看已缓存的改动： **git diff --cached**
- 查看已缓存的与未缓存的所有改动：**git diff HEAD**
- 显示摘要而非整个 diff：**git diff --stat**

显示暂存区和工作区的差异:

```
$ git diff [file]
```

显示暂存区和上一次提交(commit)的差异:

```
$ git diff --cached [file]
或
$ git diff --staged [file]
```

显示两次提交之间的差异:

```
$ git diff [first-branch]...[second-branch]
```





## 回退操作

> 这里的回退不仅仅是回到历史操作，还可以恢复被回退了之后的操作
>
> 本质上是移动HEAD指针

`git log`用于查看commit记录，显示从最近到最远的提交日志

Git的版本回退速度非常快，因为Git在内部有个指向当前版本的`HEAD`指针，当你回退版本的时候，Git仅仅是把HEAD从指向`append GPL`：

```
┌────┐
│HEAD│
└────┘
   │
   └──▶ ○ append GPL
        │
        ○ add distributed
        │
        ○ wrote a readme file
```

改为指向`add distributed`：

```
┌────┐
│HEAD│
└────┘
   │
   │    ○ append GPL
   │    │
   └──▶ ○ add distributed
        │
        ○ wrote a readme file
```

然后顺便把工作区的文件更新了。所以你让`HEAD`指向哪个版本号，你就把当前版本定位在哪。

在Git中，用`HEAD`表示当前版本，，上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本写100个`^`比较容易数不过来，所以写成`HEAD~100`。

现在，我们要把当前版本`append GPL`回退到上一个版本`add distributed`，就可以使用`git reset`命令：

```shell
$ git reset --hard HEAD^
HEAD is now at e475afc add distributed
```

关于`git reset`回退操作的参数

- `--hard`会回退到上个版本的已提交状态
- `--soft`会回退到上个版本的未提交状态
- `--mixed`会回退到上个版本已添加但未提交的状态。

**Git不仅能够回退历史操作，还能恢复操作**

```shell
$ git reset --hard <commit_id> #commit_id不用写全，可以写前几位，能和其他commit_id区分就行
```

如果不知道commit_id怎么办

- Git提供了一个命令`git reflog`用来记录你的每一次命令
- 通过该命令可获取commit_id

