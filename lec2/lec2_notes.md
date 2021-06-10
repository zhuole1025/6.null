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
  
  mcd () {
  	mkdir -p "$1" # $1相当于argv[1]
  	cd "$1"
  }
  
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
  find . -name src -type dfind . -path '**/test/**/.py' -type ffind . -mtime -1 # 查找所有在昨天修改过的文件
  find . -name "*.tmp" -exec rm {} \;
  fd "*.py" # 比find更直观的语法
  locate hello.pdf # 建立数据库，加速文件查找
  updatedb # 更新数据库
  grep -R foobarrg "import requests" -t py ~/scratch # ripgrep
  rg "import requests" -t py -C 5 ~/scratchrg -u --files-without-match "^#\!" -t shcat example.sh | fzf # 模糊匹配
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

  
