set nocompatible
filetype off

"{{ 插件安装
"git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"PluginInstall
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'                  " 插件管理工具
Plugin 'Align'                              " 对其等号
Plugin 'Shougo/neocomplcache.vim'           " 自动补全
Plugin 'scrooloose/nerdtree'                " 目录树
Plugin 'mhinz/vim-grepper'                  " 文件内容搜索
Plugin 'yssl/QFEnter'                       " quick-fix 窗口快捷键
Plugin 'majutsushi/tagbar'                  " 函数列表
Plugin 'mru.vim'                            " 最近打开的文件
Plugin 'ctrlpvim/ctrlp.vim'                 " 文件名搜索
Plugin 'ronakg/quickr-cscope.vim'           " cscope 跳转
Plugin 'lifepillar/vim-solarized8'          " solarized 主题
Plugin 'vim-airline/vim-airline'            " 状态栏
Plugin 'vim-airline/vim-airline-themes'     " 状态栏主题
Plugin 'edkolev/tmuxline.vim'               " 生成 tmuxline color
Plugin 'edkolev/promptline.vim'             " 生成 bash path color
"Plugin 'dantezhu/authorinfo'                " 插入作者信息
"Plugin 'posva/vim-vue'                      " vue syntax color
"Plugin 'mustache/vim-mustache-handlebars'   " vue 模板 syntax color
call vundle#end()
filetype plugin indent on
"}} 插件安装结束

"{{ 主题
syn enable
set background=dark
"set background=light
syn on                                 "语法支持
colorscheme solarized8_dark_high       "设置颜色主题
"}}

"{{ 通用配置
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
set autochdir
set tags=tags;/
set ignorecase              "检索时忽略大小写
set encoding=utf-8
set fileencoding=utf-8      "使用utf-8新建文件
set fileencodings=utf-8,gbk "使用utf-8或gbk打开文件
let &termencoding=&encoding "
set hls                     "检索时高亮显示匹配项
set helplang=cn             "帮助系统设置为中文
"set foldmethod=syntax      "代码折叠
set nofoldenable            "关闭代码折叠
"set term=screen
set clipboard=unnamed       " use the system clipboard
set nois                    " 设置搜索不自动跳转
set mouse=a                 " 支持鼠标滚动
"}} 通用配置结束

"{{ 快捷键配置
"conf for tabs, 为标签页进行的配置，通过ctrl h/l切换标签等
let mapleader = ','
nnoremap <C-l> gt
nnoremap <C-h> gT

"大写字母
inoremap <c-u> <esc>gUiwea
"}} 快捷键配置结束

"{{ 插件配置

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
"}

"nerdtree{ 目录树配置
map <C-T> :NERDTree<CR>
"}
"

"neocomplcache{ 自动补全
let g:neocomplcache_enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr><space>  pumvisible() ? neocomplcache#close_popup() : "\<SPACE>"
"}

"Align{ 字符对齐
vmap gn :Align=<CR>
"}

"authoinfo{ 文件头模板
nmap <F4> :AuthorInfoDetect<cr>
let g:vimrc_author='hanxi'
let g:vimrc_email='hanxi.com@gmail.com'
let g:vimrc_homepage='http://hanxi.info'
"}

"grepper{
function! FindProjectRoot(lookFor)
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.a:lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            return expand(pathMaker)
        endif
    endwhile
    return expand('%:p:h')
endfunction
let g:root_dir = FindProjectRoot('.git')
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
let g:grepper = {}
let g:grepper.ag = {}
let g:grepper.ag.grepprg = 'ag --vimgrep $* '.g:root_dir
"}

"QFEnter{
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']
"}

"promptline{
":PromptlineSnapshot ~/.shell_prompt.sh airline
let g:promptline_symbols = {
            \ 'truncation'     : '…'
            \}
let g:promptline_preset = {
            \'a' : [ promptline#slices#user() ],
            \'c' : [ promptline#slices#cwd() ],
            \'y' : [ promptline#slices#vcs_branch() ],
            \'warn' : [ promptline#slices#last_exit_code() ]
            \}
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

"tagbar{
map tb :TagbarToggle<cr>
xmap tb :TagbarToggle<cr>
"}

"ctrlp{
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
"set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ 'link': 'some_bad_symbolic_links',
            \ }
"}

"cscope{
let g:quickr_cscope_use_qf_g = 1
let g:quickr_cscope_autoload_db = 0
if has("cscope")
    let g:cscope_out = g:root_dir.'/cscope.out'
    if filereadable(g:cscope_out)
        silent exe 'cs add '.g:cscope_out.' '.g:root_dir
    endif
    set csto=1
    set cst
endif
"}

"}} 插件配置结束

" 保存时自动删除行尾空格
function! DeleteTrailingWS()
    %ret! 4
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
    :w
endfunction
"autocmd BufWrite * :call DeleteTrailingWS()
command W call DeleteTrailingWS()

" 记住上次编辑的位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" 保存执行ctags
function! UpdateTags()
    exe "!cd ".g:root_dir." && ctags -R"
    exe "!cd ".g:root_dir." && cscope -Rbqk"
    :cs reset <CR><CR>
endfunction
"autocmd BufWrite *.cpp,*.h,*.c,*.lua call UPDATE_TAGS()
command Ctags call UpdateTags()
