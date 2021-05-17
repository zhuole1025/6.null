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

