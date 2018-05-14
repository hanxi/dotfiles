"{{ 插件安装 vim-plug
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')
"PluginInstall
Plug 'scrooloose/nerdtree'                " 目录树
Plug 'ludovicchabant/vim-gutentags'       " 自动生成 tags
Plug 'mhinz/vim-grepper'                  " 文件内容搜索
Plug 'yssl/QFEnter'                       " quick-fix 窗口快捷键
Plug 'tpope/vim-fugitive'                 " git 操作
Plug 'roxma/nvim-completion-manager'      " 自动补全
Plug 'Yggdroot/LeaderF'                   " 文件列表和函数列表
Plug 'skywind3000/vim-preview'            " 预览代码

Plug 'lifepillar/vim-solarized8'          " solarized 主题
Plug 'vim-airline/vim-airline'            " 状态栏
Plug 'vim-airline/vim-airline-themes'     " 状态栏主题
Plug 'edkolev/tmuxline.vim'               " 生成 tmuxline color
Plug 'edkolev/promptline.vim'             " 生成 bash path color
call plug#end()

"{{ 主题
set background=dark
"set background=light
syn on
syn enable
colorscheme solarized8  "设置颜色主题
"}}

"{{ 通用配置
set nocompatible
set ai                      "自动缩进
set si
set bs=2                    "在insert模式下用退格键删除
set showmatch               "代码匹配
set expandtab               "以下三个配置配合使用，设置tab和缩进空格数
set shiftwidth=4
set tabstop=4
set softtabstop=4
set cursorline              "为光标所在行加下划线
set cursorcolumn            "为光标所在行加下划线
set number                  "显示行号
set autoread                "文件在Vim之外修改过，自动重新读入
set autowriteall            "设置自动保存
set ignorecase              "检索时忽略大小写
set encoding=utf-8
set fileencoding=utf-8      "使用utf-8新建文件
set fileencodings=utf-8,gbk "使用utf-8或gbk打开文件
let &termencoding=&encoding "
set hls                     "检索时高亮显示匹配项
set helplang=cn             "帮助系统设置为中文
set nofoldenable            "关闭代码折叠
set clipboard=unnamed       " use the system clipboard
set nois                    " 设置搜索不自动跳转
set noshowmode
set mouse=a                 " 支持鼠标滚动
set diffopt=vertical        " diff 窗口纵排
set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.exe              " Windows
set tags=./.tags;,.tags
set ttimeout
set ttimeoutlen=100
"}} 通用配置结束

"{{ 快捷键配置
"conf for tabs, 为标签页进行的配置，通过ctrl h/l切换标签等
let mapleader = ','
nnoremap <C-l> gt
nnoremap <C-h> gT
"}} 快捷键配置结束

"{{ 插件配置

"gutentags{
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif
"}

"airline{ 状态栏的配置
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#promptline#enabled = 0
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = ''
"}

"nerdtree{ 目录树配置
map <leader>t :NERDTreeToggle<cr>
let NERDTreeIgnore = ['\~$', '\$.*$', '\.swp$', '\.pyc$', '#.\{-\}#$']
let s:ignore = ['.xls', '.xlsx', '.mobi', '.mp4', '.mp3']

for s:extname in s:ignore
    let NERDTreeIgnore += [escape(s:extname, '.~$')]
endfor

let NERDTreeRespectWildIgnore = 1
let g:NERDTreeChDirMode       = 0
"}

"grepper{
" 查找工程目录
function! FindProjectRoot(lookFor)
    let s:root=expand('%:p:h')
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.a:lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            let s:root=expand(pathMaker)
        endif
    endwhile
    return s:root
endfunction
let g:root_dir = FindProjectRoot('.git')
autocmd BufEnter * silent! lcd g:root_dir
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
let g:grepper = {}
let g:grepper.ag = {}
let g:grepper.ag.grepprg = 'ag --vimgrep $* '.g:root_dir
"}

"QFEnter{
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['t']
"}

"LeaderF{
let g:Lf_ShortcutF = '<c-p>'
noremap <c-n> :LeaderfMru<cr>
noremap <m-p> :LeaderfFunction<cr>
let g:Lf_MruMaxFiles = 64
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
"}

"NCM{
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"}

"vim-preview{
noremap <m-u> :PreviewScroll -1<cr>
noremap <m-d> :PreviewScroll +1<cr>
inoremap <m-u> <c-\><c-o>:PreviewScroll -1<cr>
inoremap <m-d> <c-\><c-o>:PreviewScroll +1<cr>
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
noremap <m-n> :PreviewSignature!<cr>
inoremap <m-n> <c-\><c-o>:PreviewSignature!<cr>
noremap <leader>g :PreviewTag<cr>
inoremap <leader>g <c-\><c-o>:PreviewTag<cr>
"}

"promptline{
":PromptlineSnapshot ~/.shell_prompt.sh airline
let g:promptline_symbols = {
            \ 'truncation'     : '…'
            \ }
let g:promptline_preset = {
            \ 'a' : [ promptline#slices#user() ],
            \ 'c' : [ promptline#slices#cwd() ],
            \ 'y' : [ promptline#slices#vcs_branch() ],
            \ 'warn' : [ promptline#slices#last_exit_code() ]
            \ }
"}

"tmuxline{
":Tmuxline airline
":TmuxlineSnapshot ~/.tmux/tmuxline.conf
let g:tmuxline_preset = {
            \'a'    : '#S',
            \'win'  : '#I #W',
            \'cwin' : '#I #W #F',
            \'x'    : '%Y-%m-%d',
            \'y'    : '%H:%M:%S',
            \'z'    : "#(ifconfig | grep inet[^6] | awk -F'[:\t ]+' '{print $3,$4}' | sed 's/netmask//; s/addr//; s/ //' | grep -v '127.0.0.1' | grep -v '^10.0')",
            \'options': {
            \'status-justify':'left'}
            \}
"}

"}} 插件配置结束

"{ 保存时自动删除行尾空格
function! DeleteTrailingWS()
    %ret! 4
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
    :w
endfunction
command W call DeleteTrailingWS()
"}

"{ 记住上次编辑的位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
"}
