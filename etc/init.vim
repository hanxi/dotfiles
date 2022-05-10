set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" setting only for nvim
function! CheckVersion()
    if (!has('nvim'))
        return 0
    endif
    if (!has('python') && !has('python3'))
        return 0
    endif
    return 1
endfunction


"call plug#begin('~/.vim/plugged')
if CheckVersion()
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' } " Fuzzy search. 文件列表，函数列表，Mru文件列表，rg grep
endif

"call plug#end()

set shortmess+=c


"neovim clipborad{
let g:clipboard = {
            \'copy': { '+': 'oclip -i', '*': 'oclip -i' },
            \'paste': { '+': 'oclip -o', '*': 'oclip -o' },
            \'name': 'oclip',
            \}
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
let filetypes = "-t proto -t c -t py -t lua -t vim -t sh"
" select gs searce select word
xnoremap gs :<C-U><C-R>=printf("Leaderf! rg -F %s --nowrap --stayOpen -e %s ", filetypes, leaderf#Rg#visual())<cr><cr>
" leader g search current word
noremap <leader>g :<C-U><C-R>=printf("Leaderf! rg -F %s --nowrap --stayOpen -e %s ", filetypes, expand("<cword>"))<cr><cr>

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
"}

