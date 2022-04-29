"{{ 插件安装 vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! CheckVersion()
    if (v:version < 801 && !has('nvim'))
        return 0
    endif
    if (!has('python') && !has('python3'))
        return 0
    endif
    return 1
endfunction

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'                        " 目录树
Plug 'yssl/QFEnter'                               " quick-fix 窗口快捷键
Plug 'tpope/vim-fugitive'                         " git 操作
Plug 'skywind3000/vim-preview'                    " 预览代码

Plug 'KeitaNakamura/neodark.vim'                  " 颜色主题 neodark
Plug 'vim-airline/vim-airline'                    " 状态栏
Plug 'vim-airline/vim-airline-themes'             " 状态栏主题
Plug 'edkolev/tmuxline.vim'                       " 生成 tmuxline color
Plug 'edkolev/promptline.vim'                     " 生成 bash path color
Plug 'plasticboy/vim-markdown'                    " markdown 语法高亮

if CheckVersion()
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }} " markdown 预览
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' } " Fuzzy search. 文件列表，函数列表，Mru文件列表，rg grep
Plug 'roxma/vim-hug-neovim-rpc'                   " for vim8 use ncm2
Plug 'roxma/nvim-yarp'                            " for ncm2
Plug 'ncm2/ncm2'                                  " 自动补全
Plug 'ncm2/ncm2-bufword'                          " ncm2
Plug 'ncm2/ncm2-path'                             " ncm2
endif

call plug#end()

"{{ 主题
syn on
syn enable
set t_Co=256

let g:left_sep=""
let g:left_alt_sep=""
let g:right_sep=""
let g:right_alt_sep=""

"fonts from https://github.com/ryanoasis/nerd-fonts

"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

if !empty(globpath(&rtp, "colors/neodark.vim"))
    let g:neodark#solid_vertsplit = 1
    let g:airline_theme='papercolor'
    "let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " fixed color for $TERM=screen-256color
    "let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    colorscheme neodark
endif
"}}

"{{ 通用配置
set nocompatible
set ai                                  "自动缩进
set si
set bs=2                                "在insert模式下用退格键删除
set showmatch                           "代码匹配
"设置tab和缩进空格数
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set cursorline                          "为光标所在行加下划线
set cursorcolumn                        "为光标所在行加下划线
set number                              "显示行号
set autoread                            "文件在Vim之外修改过，自动重新读入
set autowriteall                        "设置自动保存
set ignorecase                          "检索时忽略大小写
set encoding=utf-8
set fileencoding=utf-8                  "使用utf-8新建文件
set fileencodings=utf-8,gbk             "使用utf-8或gbk打开文件
let &termencoding=&encoding
set hls                                 "检索时高亮显示匹配项
set helplang=cn                         "帮助系统设置为中文
set nofoldenable                        "关闭代码折叠
set clipboard=unnamed                   " use the system clipboard
set nois                                " 设置搜索不自动跳转
set noshowmode
set mouse=a                             " 支持鼠标滚动
set diffopt=vertical                    " diff 窗口纵排
set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class
set wildignore+=*.so,*.swp,*.zip        " MacOSX/Linux
set wildignore+=*.exe                   " Windows
set tags=./.tags;,.tags
set ttimeout
set ttimeoutlen=100
set hidden
set nobackup
set nowritebackup
set updatetime=300
set belloff=all                         " 关闭闪烁
if CheckVersion()
    set shortmess+=c
endif
"}} 通用配置结束

"{{ 快捷键配置
"conf for tabs, 为标签页进行的配置，通过ctrl h/l切换标签等
let mapleader = ','
nnoremap <C-l> gt
nnoremap <C-h> gT
"}} 快捷键配置结束

"{{ 配置行尾标识符
" Need use font: Source Code Pro
let g:hi_list=0
func! HiList()
    if g:hi_list==0
        let g:hi_list=1
        " 高亮行尾空格和中间 tab
        "highlight RedundantSpaces ctermbg=red guibg=red
        "match RedundantSpaces /\s\+$\|\t/
        set list listchars=tab:→\ ,trail:·,eol:¬,extends:…,precedes:…
    else
        let g:hi_list=0
        "hi clear RedundantSpaces
        set nolist
    endif
endfunc

noremap <leader>h :call HiList()<cr>
"}}

"{{ 查找工程目录
function! SearchRoot()
  let l:scm_list = ['.root', '.svn', '.git']
  for l:item in l:scm_list
    let l:dirs = finddir(l:item, '.;', -1)
    if !empty(l:dirs)
      return fnamemodify(l:dirs[-1].'/../', ':p:h')
    endif
  endfor
  return getcwd()
endfunction
let g:root_dir = SearchRoot()
autocmd BufEnter * exe ':cd '.g:root_dir
"}}

"{{ 插件配置

"nerdtree{ 目录树配置
function! ToggleNERDTree()
    silent exe ':NERDTree '.expand('%:p:h')
endfunction
map <leader>t :call ToggleNERDTree()<cr>
let NERDTreeIgnore = ['\~$', '\$.*$', '\.swp$', '\.pyc$', '#.\{-\}#$']
let s:ignore = ['.pb', '.xls', '.xlsx', '.mobi', '.mp4', '.mp3']

for s:extname in s:ignore
    let NERDTreeIgnore += [escape(s:extname, '.~$')]
endfor

let NERDTreeRespectWildIgnore = 1
let g:NERDTreeChDirMode           = 0
"}

"QFEnter{
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['t']
"}

"LeaderF{
let g:Lf_ShortcutF = '<c-p>'
noremap <c-m> :LeaderfMru<cr>
noremap <c-n> :LeaderfFunction<cr>
let g:Lf_WorkingDirectory = g:root_dir
let g:Lf_MruMaxFiles = 64
let g:Lf_StlSeparator = { 'left': g:left_sep, 'right': g:right_sep, 'font': '' }
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 1
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_ShowDevIcons = 0
" 搜索选中的字符串，对结果按 i 支持二次过滤
let g:Lf_RgConfig = [
    \ "--max-columns=150",
    \ "--type-add proto:*.proto",
    \ "--glob=!git/*",
    \ "--follow --no-ignore"
    \ ]
" select gs searce select word
xnoremap gs :<C-U><C-R>=printf("Leaderf! rg -F -t proto -t c -t py -t lua --nowrap --stayOpen -e %s ", leaderf#Rg#visual())<cr><cr>
" leader g search current word
noremap <leader>g :<C-U><C-R>=printf("Leaderf! rg -F -t proto -t c -t py -t lua --nowrap --stayOpen -e %s ", expand("<cword>"))<cr><cr>

" gtags
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
let g:Lf_Gtagsconf = expand('~/.local/etc/gtags.conf')
" definition 
noremap <leader>d :<C-U><C-R>=printf("Leaderf! gtags -d %s", expand("<cword>"))<cr><cr>
" reference 
noremap <leader>r :<C-U><C-R>=printf("Leaderf! gtags -r %s", expand("<cword>"))<cr><cr>
" symbol 
noremap <leader>s :<C-U><C-R>=printf("Leaderf! gtags -s %s", expand("<cword>"))<cr><cr>
" grep
"noremap <leader>g :<C-U><C-R>=printf("Leaderf! gtags -g %s", expand("<cword>"))<cr><cr>

function! ClosePluginWindow()
    " Close quickfix
    cclose

    " Close Leaderf Buffer
    redir => message
        silent execute "ls!"
    redir END
    let l:buflist = split(message, '\n')
    for l:one in l:buflist
        let l:items = split(l:one, '"')
    if match(l:items[0], "u*a-") >= 0
        let l:bufid = matchstr(l:items[0], '\d\+')
        exe 'bd! '.l:bufid
    endif
    endfor
endfunction
" 关闭插件窗口
map <C-C><C-C> :call ClosePluginWindow()<cr>
"}

"NCM2{
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" enable ncm2 for all buffers
if CheckVersion()
    autocmd BufEnter * call ncm2#enable_for_buffer()
    " IMPORTANTE: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect
endif
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
"}

"airline{
let g:airline_powerline_fonts = 0
let g:airline_left_sep=g:left_sep
let g:airline_left_alt_sep=g:left_alt_sep
let g:airline_right_sep=g:right_sep
let g:airline_right_alt_sep=g:right_alt_sep
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z' ]
      \ ]
"}

"promptline{
":PromptlineSnapshot! ~/.local/etc/shell_prompt.sh airline
let g:promptline_symbols = {
            \ 'left'          : g:left_sep,
            \ 'left_alt'      : g:left_alt_sep,
            \ 'right'         : g:right_sep,
            \ 'right_alt'     : g:right_alt_sep,
            \ 'dir_sep'       : " > ",
            \ 'truncation'    : "\u22EF",
            \ 'vcs_branch'    : "\u16A0 "}
if !empty(globpath(&rtp, "promptline.vim"))
    let g:promptline_preset = {
                \ 'a' : [ promptline#slices#user() ],
                \ 'c' : [ promptline#slices#cwd() ],
                \ 'y' : [ promptline#slices#vcs_branch() ]}
endif
"}

"tmuxline{
":Tmuxline airline
":TmuxlineSnapshot! ~/.local/etc/tmuxline.conf
let g:tmuxline_separators = {
            \ 'left'     : g:left_sep,
            \ 'left_alt' : g:left_alt_sep,
            \ 'right'    : g:right_sep,
            \ 'right_alt': g:right_alt_sep}
    
let g:tmuxline_preset = {
            \'a'    : '#S',
            \'win'  : '#I #W',
            \'cwin' : '#I #W #F',
            \'x'    : '%Y-%m-%d',
            \'y'    : '%H:%M:%S',
            \'z'    : "#(ip -4 a| grep inet | awk '{print $2}' | grep -v '127.0.0.1' | head -1)",
            \'options': {
            \'status-justify':'left'}
            \}
"}

"{ vim-markdown
let g:vim_markdown_folding_disabled = 1
"}

"{markdown-preview
let g:mkdp_open_to_the_world = 1
let g:mkdp_open_ip = 'localhost'
let g:mkdp_port = 6060
function! g:Open_browser(url)
    silent exe '!lemonade open 'a:url
endfunction

" 设置调用的函数的名字
let g:mkdp_browserfunc = 'g:Open_browser'
"}

"neovim clipborad{
let g:clipboard = {
            \'copy': { '+': 'oclip -i', '*': 'oclip -i' },
            \'paste': { '+': 'oclip -o', '*': 'oclip -o' },
            \'name': 'oclip',
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
command! W call DeleteTrailingWS()
"}

"{ 记住上次编辑的位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
"}

"{ 格式化json文件
command! Jsonf :execute '%!python -c "import json,sys,collections,re; sys.stdout.write(re.sub(r\"\\\u[0-9a-f]{4}\", lambda m:m.group().decode(\"unicode_escape\").encode(\"utf-8\"),json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=2)))"'
"}

