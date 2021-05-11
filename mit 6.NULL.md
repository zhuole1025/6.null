# MIT 6.NULL: The Missing Semester if Your CS Education

## Lecture 1: Course Overview + The Shell

### Overview

这门课程的主题就是教会我们如何使用那些不论是在科研或是工程中都会对我们大有帮助的工具。整个课程共有11个小时，根据所教授的工具分成了不同lectures，可以任意阅读学习需要的某一章节。

### Shell

* Shell prompt

* ```shell
  date # 显示当前日期
  echo hello # 显示echo后面的参数
  echo hello\ world # 输入含空格的参数
  echo "hello world"
  ```

* Environment variables

  * Path variable: shell通过搜索到系统内置的程序来解析并执行对应的命令，而搜索的路径正是按照path所规定的目录来进行搜索

    ```shell
    echo $PATH
    which echo # 显示执行echo命令时的搜索路径
    ```

* Navigating in the shell

  * Absolut Path: 绝对路径，给出该文件的完整路径，以`/`开始
  * Relative Path: 相对路径，给出相对于当前位置的路径
  * 当我们运行一个程序时，一般来说都会在当前目录下执行

  ```shell
  pwd # 显示当前工作目录
  cd /home # 改变当前工作目录
  . # 当前工作目录
  .. # 上一级工作目录
  cd ..
  cd ./home
  ls # 列出当前目录中所有文件
  ls ..
  ~ # 根目录
  cd ~/Desktop
  - # 上一次所在的目录
  cd - # 相当于Ctrl Z
  ```

* Flags and options: 通常通过`-`或者`--`来获取命令的帮助或配置参数

  ```shell
  ls -- help
  ls -l
  ```

* ```shell
  mv dotfile.md foo.md # 重命名文件
  mv foo.md .. # 移动文件
  cp foo.md ../food.md # 拷贝文件
  rm foo.md # 删除文件
  rmdir "Mt Photos"
  mkdir hello # 新建目录
  ```
* ```shell
  Ctrl L # 清空工作区
  ```

* 连接程序：stream

  * 输入输出重定向（默认均为terminal）

    ```shell
    echo hello > hello.txt  # 输出重定向到对应文件
    cat hello.txt # 显示文件内容
    cat < hello.txt > hello2.txt 
    cat < hello.txt >> hello2.txt # 使用>>可以拼接到重定向文件的末尾
    ```

  * 多个命令结合：pipes

    ```shell
    xxxx | xxxx # 将左边命令的输出作为右边命令的输入
    ls -l / | tail -n1 # 显示当前目录文件的最后一行
    ls -l / | tail -n1 > ls.txt
    curl --head --silent google.com | grep -i content-length
    curl --head --silent google.com | grep -i content-length | cut --delimiter=' ' -f2
    ```

* Root user

  ```shell
  sudo su # 法一：进入root用户
  echo 1060 | sudo tee brightness # 法二：以root权限执行tee命令，将1060作为输入，同时写入到文件brightness和屏幕中
  sudo echo 3 > brightness # 错误：shell先执行的 > brightness被拒绝
  ```

  * 注意：`<`、`>`、`｜`  等操作都是直接被shell执行，而非独立的程序，如`echo`

* 打开文件

  ```shell
  xdg-open lectures.html # Linux下打开文件
  open lectures.html # Macos下打开文件
  ```


## Lecture 2: Shell Tools and Scripting

### Shell Scripting

* 变量

  ```shell
  foo=bar # 注意不可以有空格
  echo $foo
  echo "Value is $foo" # $foo被替换为变量的值
  echo 'Value is $foo' # 单引号内所有内容均视为字符串
  ```

* 函数

  ```shell
  vim mcd.sh
  ​```
  mcd () {
  	mkdir -p "$1" # $1相当于argv[1]
  	cd "$1"
  }
  ​```
  source mcd.sh
  mcd test
  ```

* `$`

  * `$0` 脚本名称
  * `$1` 到 `$9` 脚本的参数
  * `$@` 所有的参数
  * `$?` 最后命令的退出情况
  * `$_` 获得上一个命令的最后一个参数，等于`Esc` + `.`
  * `$#` 传递的参数的个数
  * `$$` 当前shell或脚本运行的进程号
  * `!!` 上一条命令，包括参数，常用于`sudo !!`

  ```shell
  echo "hello"
  echo $?
  echo foobar mcd.sh
  echo $?
  true
  echo $?
  ```

* 逻辑运算符

  * `true`, `false`, `&&`, `|| `...

  ```shell
  false || echo "Oops fail"
  true || echo "Will not be printed" # 逻辑短路
  true && echo "Things went well"
  false ; echo "Will always be printed"
  ```

* Command subsititution

  ```shell
  foo=$(pwd)
  echo $foo
  echo "We are in $(pwd)"
  ```

* Process subsititution: 执行`<()` 里的命令，并将结果存在一个暂时的文件中，用该文件名替换 `<()`

  ```shell
  cat <(ls) <(ls ..)
  ```

* 脚本例子

```shell
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then # [[  ]] 内用于比较，-ne 是不相等
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

* 通配（globbing）

  * `*` 匹配任意长度的字符
  * `?` 匹配一个任意字符
  * `{}` 扩展大括号内的内容

  ```shell
  ls *.sh
  ls project?
  convert image.png image.jpg
  convert image.{png,jpg}
  touch project{1,2}/src/test/test{1,2,3}.py
  mkdir foo bar
  touch {foo,bar}/{a..j}
  ```

* Shebang

  *  `#!` : 一般在脚本的第一行，后接执行这个脚本文件的解释器的绝对路径与参数，便于该脚本在不同的机器和系统上运行

  ```shell
  #!/usr/local/bin/python
  #!/usr/bin/env python # 更通用
  ```

* debug

  ```shell
  shellcheck mcd.sh
  ```

* Script 和 Function 的区别

  * 函数必须使用和shell相同的语言，脚本可以使用任意语言，因此脚本需要引入 Shebang
  * 函数只在读入定义的时候被加载一次，而脚本在每次被执行时候都被加载。因此，函数的内容一旦被改变就需要重新加载。
  * 函数在当前shell环境下被执行，因此可以修改环境变量（比如当前目录）；而脚本不在当前shell环境下执行，环境变量通过export来实现传值
  * 函数对于模块化的实现很重要，通常shell脚本会包含自己的函数定义

### Shell Tools

* 获得帮助

  ```shell
  man ls # 显示使用文档，按q退出
  tldr tar # too long, don't read 给出更简洁的文档
  ```

* 查找文件及其内容

  ```shell
  find . -name src -type d
  find . -path '**/test/**/.py' -type f
  find . -mtime -1 # 查找所有在昨天修改过的文件。
  find . -name "*.tmp" -exec rm {} \;
  fd "*.py" # 比find更直观的语法
  locate hello.pdf # 建立数据库，加速文件查找
  updatedb # 更新数据库
  grep -R foobar
  rg "import requests" -t py ~/scratch # ripgrep
  rg "import requests" -t py -C 5 ~/scratch
  rg -u --files-without-match "^#\!" -t sh
  cat example.sh | fzf # 模糊匹配
  ```

* 查找shell命令

  ```shell
  history
  history 1 | grep c
  Ctrl+R # backward search
  ```

* 目录结构
  
  ```shell
  tree
  broot
  nnn
  ranger
  ```
  
* 切换目录

  ```shell
  ln -s # 建立软连接
  fasd
  ```

  