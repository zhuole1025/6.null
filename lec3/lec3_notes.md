## Lecture3: Editors (Vim)

* Vim 是 modal editor，有不同的 operating modes

  * Normal mode: 默认模式，在其他模式中按 `<esc>` 来返回

  * Insert mode: 按 `i` 进入

  * Replace mode: 按 `R` 进入

  * Visual mode: 按 `v` 进入

    * Visual line mode: 按 `Shift-v` 进入

    * Visual block mode: 按 `Ctrl-v` 进入

  * Command-line mode: 按 `:` 进入

* 使用vim

  ```shell
  vim
  vim notes.md
  ```

* Buffers, Windows, Tabs

  * Buffers: 缓冲区，可以理解为与打开的文件一一对应
  * Windows: 窗口，是缓冲区的可视化界面。同一个文件可以打开多个窗口。
  * Tabs: 选项卡，是一系列缓冲区或者窗口集合的布局。
  * 使用方法：
    * 同时将任务所需的所有文件放入缓冲区
    * 关闭使用结束或者多余的窗口，避免视觉混乱
    * 选项卡起到分类的作用

* Command-line mode

  * `:quit`，`q` : 关闭当前窗口

  * `:w` : 保存
    * `w {filename}` : 以指定名称保存文件
    * `:wq` : 保存并关闭
    * `:!q` : 不保存并关闭
    
  * `:e {name of file}` : 打开文件

  * `:ls` : 显示打开的buffers

  * `:!{command}` : 可以执行外部 shell 命令

  * `:help {command)"`: 打开命令的帮助
    * `:help :w`
    * `:help w`
    
  * `:s` : 替换
    
    * 
      ```shell
      %s/foo/bar/g # replace foo with bar globally in file
      %s/\[.*\](\(.*\))/\1/g # replace named Markdown links with plain URLs
      ```
    
  * `:r {name}` : 插入文件中的内容
    * `:r !ls`
    
  * `:set {command}` : 设置
    * `set ic` : 忽略大小写
    * `Ctrl-D`，`<TAB>` : 分别展示可能的补全结果和进行补全

* Open buffers

  * `:tabnew` : 建立新窗口
  * `:tabp`，`:tabn` : 向前或向后切换标签页
  * `:tabc` : 关闭标签
  * `:tabo` : 关闭其他所有标签
  * `:sp`，`:vsp` : 同一个 buffer 可以在多个窗口中打开
  * `:qa` : 关闭所有窗口
  * `:Ctrl w + {h,j,k,l}` : 来切换分屏
  * `:res {+,-}{number}` : 来调整分屏大小
* Normal mode

  * 移动操作
    * `h`，`j`，`k`，`l` : 分别控制光标向左、下、上、右移动
    * `w`，`b`，`e` : 分别控制光标移动到下一个单词、当前单词开头、当前单词结尾
    * `0`，`$` : 分别控制光标移动到本行开头和末尾的位置
    * `^` : 控制光标移动到本行第一个非空格的位置
    * `:{number}<CR>`，`{number}G` : 使光标跳至对应行
    * `Ctrl-U`，`Ctrl-D` : 分别使页面上翻与下翻
    * `gg`，`G` : 分别移动光标到文件开头和结尾
    * `Ctrl-g` : 查看当前行号
    * `H`，`M`，`L` : 分别移动光标到当前屏幕所显示内容的第一行，中间行，最后一行
    * `f{charactor}`，`F{charactor}` : 后接需要查找的字母，分别将光标向前或向后移动至行内第一个匹配的字母
    * `t{charactor}`，`T{charactor}` : 后接需要查找的字母，分别将光标向前或向后移动至行内第一个匹配的字母之前或之后
    * `/`，`?` : 后接需要查找的字符串，回车结束输入并分别将光标向后/向前移动至第一个匹配的地方，`n` 跳至下一个匹配的地方
      * `N`，`n` : 分别将光标移至上一个或下一个匹配的位置
      * `Ctrl-o`，`Ctrl-i` : 分别回到之前或之后的位置
    * `%` : 在括号处使用来跳转至匹配的括号
  * 编辑操作
    * `o` ，`O `: 分别在下方或上方插入一个空行，并且进入 insert mode
    * `d{motion}` : 后面接移动操作进行删除
    * `c{motion}` : 后面接移动操作进行删除，并进入 insert mode
    * `u` : 撤销
    * `U` : 撤销本行之前所有命令
    * `.` : 重复之前的命令
    * `Ctrl-r` : 撤销之前的撤销命令（Ctrl-z）
    * `dd` : 重复输入命令等于对当前行施加该命令
    * `x` : 删除当前字符
    * 注意：被删除的内容会被放在寄存器中，可以粘贴
    * `r`，`R` : 后接要替换的字符，并替换当前单个/多个字符
    * `y` : 后接移动操作进行复制
    * `p` : 粘贴
    * `A`，`a` : 分别在行末和光标处进入 insert mode
  * 计数
    * `3w` : 数字N+操作 = 执行x次该操作
    * `40G` : 跳转至文件第40行
  * modifiers
    * `i` : inside
    * `a` : around

* Visual mode

  * 进入 visual mode 后基本上可以使用 normal mode 的所有操作，进行的移动操作会选中对应的字符，常用于先选中然后按 `y` 复制，返回 normal mode 后再粘贴
  * Visual line mode 以行为单位选中
  * Visual block mode 以矩形框为单位选中
  * 在 Visual mode 选中后通过 `:normal {command}` 来实现对选中的每一行执行对应的命令

* Marcos （宏）

  * `q{character}` 开始在 `{character}` 中录制一个宏
  * `q` 停止录制宏
  * `@{character}` 重复宏
  * 宏遇到错误时停止执行
  * `{number}@{character}` 执行 `{number}` 次宏
  * 宏可以递归调用

* Vim 可以进行配置 (vimrc) ，安装各种插件

  * [vimawesome](https://vimawesome.com)
  * [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): fuzzy file finder
  * [ack.vim](https://github.com/mileszs/ack.vim): code search
  * [nerdtree](https://github.com/scrooloose/nerdtree): file explorer
  * [vim-easymotion](https://github.com/easymotion/vim-easymotion): magic motions

* Vim emulation mode

  * Bash: `set -o vi`
  * Zsh: `binfkey -v`
  * Fish: `fish_vi_key_bindings`
