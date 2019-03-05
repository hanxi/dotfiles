"{{ 插件安装 vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'                        " 目录树
Plug 'jsfaint/gen_tags.vim'                       " 自动生成 tags
Plug 'yssl/QFEnter'                               " quick-fix 窗口快捷键
Plug 'tpope/vim-fugitive'                         " git 操作
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' } " Fuzzy search. 文件列表，函数列表，Mru文件列表，rg grep
Plug 'skywind3000/vim-preview'                    " 预览代码

Plug 'KeitaNakamura/neodark.vim'                  " 颜色主题 neodark
Plug 'vim-airline/vim-airline'                    " 状态栏
Plug 'vim-airline/vim-airline-themes'             " 状态栏主题
Plug 'edkolev/tmuxline.vim'                       " 生成 tmuxline color
Plug 'edkolev/promptline.vim'                     " 生成 bash path color
Plug 'plasticboy/vim-markdown'                    " markdown 语法高亮
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }} " markdown 预览

Plug 'roxma/vim-hug-neovim-rpc'                   " for vim8 use ncm2
Plug 'roxma/nvim-yarp'                            " for ncm2
Plug 'ncm2/ncm2'                                  " 自动补全
Plug 'ncm2/ncm2-bufword'                          " ncm2
Plug 'ncm2/ncm2-path'                             " ncm2

call plug#end()

"{{ 主题
syn on
syn enable
set t_Co=256

if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

if !empty(globpath(&rtp, "colors/neodark.vim"))
    let g:neodark#solid_vertsplit = 1
    let g:airline_theme='papercolor'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " fixed color for $TERM=screen-256color
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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
"set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
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

"gen_tags{
" 将自动生成的 tags 文件全部放入 ~/.cache/tags_dir 目录中，避免污染工程目录
let g:gen_tags#use_cache_dir = 1
" disable ctags
let g:loaded_gentags#ctags = 1
" auto gtags
let g:gen_tags#gtags_auto_gen = 1
" disable map
let g:gen_tags#gtags_default_map = 0
" set working dir
let g:gen_tags#root_path = g:root_dir
" qucick for gtags
if v:version >= 800
    set cscopequickfix=s+,c+,d+,i+,t+,e+,g+,f+,a+
else
    set cscopequickfix=s+,c+,d+,i+,t+,e+,g+,f+
endif

function! s:gen_tags_find(cmd, keyword) abort
    " Mark this position
    execute "normal! mY"
    " Close any open quickfix windows
    cclose
    " Clear existing quickfix list
    cal setqflist([])

    let l:cur_buf=@%
    let l:cmd = 'cs find ' . a:cmd . ' ' . a:keyword
    silent! keepjumps execute l:cmd

    if len(getqflist()) > 1
        " If the buffer that cscope jumped to is not same as current file, close the buffer
        if l:cur_buf != @%
            " Go back to where the command was issued
            execute "normal! `Y"
            " delete previous buffer.
            bdelete #
        endif
        copen
    endif
endfunction

noremap <leader>c :call <SID>gen_tags_find('c', "<C-R><C-W>")<cr>
noremap <leader>f :call <SID>gen_tags_find('f', "<C-R><C-F>")<cr>
noremap <leader>g :call <SID>gen_tags_find('g', "<C-R><C-W>")<cr>
noremap <leader>i :call <SID>gen_tags_find('i', "<C-R><C-F>")<cr>
noremap <leader>s :call <SID>gen_tags_find('s', "<C-R><C-W>")<cr>

" gtags
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = expand('~/.local/etc/gtags.conf')
"let g:gen_tags#verbose = 1
"}

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
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
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
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 1
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
" 搜索选中的字符串，对结果按 i 支持二次过滤
let g:Lf_RgConfig = [
    \ "--max-columns=150",
    \ "--type-add proto:*.proto",
    \ "--glob=!git/*"
    \ ]
xnoremap gs :<C-U><C-R>=printf("Leaderf! rg -F -t proto -t c -t py -t lua --nowrap --stayOpen -e %s ", leaderf#Rg#visual())<cr><cr>

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
autocmd BufEnter * call ncm2#enable_for_buffer()
" IMPORTANTE: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
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
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_close_button = 0
"}

"promptline{
":PromptlineSnapshot! ~/.local/etc/shell_prompt.sh airline
let g:promptline_symbols = {
        \ 'truncation'     : '…'
        \ }
if !empty(globpath(&rtp, "promptline.vim"))
    let g:promptline_preset = {
                \ 'a' : [ promptline#slices#user() ],
                \ 'c' : [ promptline#slices#cwd() ],
                \ 'y' : [ promptline#slices#vcs_branch() ],
                \ 'warn' : [ promptline#slices#last_exit_code() ]
                \ }
endif
"}

"tmuxline{
":Tmuxline airline
":TmuxlineSnapshot! ~/.local/etc/tmuxline.conf
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

"{ vim-markdown
let g:vim_markdown_folding_disabled = 1
"}

"{markdown-preview
let g:mkdp_open_to_the_world = 1
let g:mkdp_open_ip = '127.0.0.1'
let g:mkdp_port = 8080
function! g:Open_browser(url)
    silent exe '!lemonade open 'a:url
endfunction

" 设置调用的函数的名字
let g:mkdp_browserfunc = 'g:Open_browser'
"}

"neovim clipborad{
let g:clipboard = {
            \'copy': { '+': 'lemonade copy', '*': 'lemonade copy' },
            \'paste': { '+': 'lemonade paste', '*': 'lemonade paste' },
            \'name': 'lemonade',
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

"{ 热更服务器
function! HotFixServer(server)
    let s:server = tolower(a:server)
    if s:server == ''
        let s:server = 'gamed'
    endif
    if expand('%:e') == 'c'
        let s:autoupdatefile = g:root_dir.'/etc/autoupdate_'.s:server
        if filereadable(s:autoupdatefile)
            let l:curfile = substitute(expand('%:p'), g:root_dir, "", "")
            let l:context = l:curfile
            silent exe '!echo -e 'l:context' > 's:autoupdatefile
            :redraw!
            :echo "Updated ".s:autoupdatefile
        else
            :echo "Error! Hot need create ".s:autoupdatefile." file."
        endif
    else
        :echo "Error! Hot only support *.c file."
    endif
endfunction
" :H [gamed/netd...] 命令自动热更当前编辑的文件，默认gamed
command! -nargs=? H call HotFixServer(<q-args>)
"}

