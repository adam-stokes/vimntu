#!/usr/bin/env perl

use strict;
use warnings;
use 5.008;
use YAML;
use File::chdir;
use File::Spec::Functions qw[catdir catfile];
use File::Slurp;
use File::HomeDir;

sub initialize {
	my ($conf) = @_;
	my $home = File::HomeDir->my_home;
	my $vimrc = catfile($home, ".vimrc");
	die("you need to remove .vim to proceed.") unless ! -d catdir($home, ".vim");
	foreach (@{$conf->{script}}) {
		print "running: $_\n";
		`$_`;
	}
	local $CWD = $ENV{HOME}.'/.vim/bundle';
	foreach (@{$conf->{plugins}}) {
		`git clone -q $_`;
	}
	write_file($vimrc, {binmode => ':raw'}, $conf->{config});
}

###############################################################################
# YAML Configuration
###############################################################################
my $vim_conf = YAML::Load << '...';
---
name: vim
description: VIM Text Editor and plugins
config: |
  execute pathogen#infect()
  syntax on
  filetype plugin indent on
  
  set background=dark
  colorscheme jellybeans
  set textwidth=79
  set formatoptions=qrn1
  if exists('+colorcolumn')
    set colorcolumn=80
  endif
  set list
  set listchars=tab:.\ ,trail:.,extends:#,nbsp:.
  if has("gui_running")
    set guifont=Monospace\ 10
    set list
    set listchars=tab:▸\ ,eol:¬,extends:#,nbsp:.,trail:.
    set guioptions-=r
    set go-=L
    set go-=T
  endif
  
  set numberwidth=5
  set cursorline
  set cursorcolumn
  set guicursor+=a:blinkon0
  nmap <c-up> ddkP
  nmap <c-down> dd
  nmap + <c-w>+
  nmap _ <c-w>-
  nmap > <c-w>>
  nmap < <c-w><
  vmap <c-up> xkP`[V`]
  vmap <c-down> xp`[V`]
  
  au BufEnter * silent! lcd %:p:h " auto change directory of current file
  au WinLeave * set nocursorline nocursorcolumn
  au WinEnter * set cursorline cursorcolumn
  set cursorline cursorcolumn
  if ! has('gui_running')
      set ttimeoutlen=10
      augroup FastEscape
  	autocmd!
  	au InsertEnter * set timeoutlen=0
  	au InsertLeave * set timeoutlen=1000
      augroup END
  endif
  autocmd GUIEnter * set vb t_vb= " for your GUI
  autocmd VimEnter * set vb t_vb=
packages:
  - vim
  - vim-gtk
plugins:
  - git://github.com/antono/html.vim
  - git://github.com/juvenn/mustache.vim
  - git://github.com/kien/ctrlp.vim
  - git://github.com/klen/python-mode
  - git://github.com/nanotech/jellybeans.vim
  - git://github.com/othree/html5.vim
  - git://github.com/pangloss/vim-javascript
  - git://github.com/rodjek/vim-puppet
  - git://github.com/sickill/vim-pasta
  - git://github.com/tpope/vim-bundler
  - git://github.com/tpope/vim-endwise
  - git://github.com/tpope/vim-eunuch
  - git://github.com/tpope/vim-fugitive
  - git://github.com/tpope/vim-haml
  - git://github.com/tpope/vim-markdown
  - git://github.com/tpope/vim-rails
  - git://github.com/tpope/vim-scriptease
  - git://github.com/tpope/vim-sensible
  - git://github.com/tpope/vim-surround
  - git://github.com/tpope/vim-unimpaired
  - git://github.com/vim-perl/vim-perl
  - git://github.com/vim-ruby/vim-ruby
  - git://github.com/vim-scripts/taglist.vim
  - git://github.com/vimoutliner/vimoutliner
  - git://github.com/bling/vim-airline
  - git://github.com/Yggdroot/indentLine
script:
  - mkdir -p ~/.vim/autoload ~/.vim/bundle
  - curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  - sudo apt-add-repository -y ppa:nmi/vim-snapshots
  - sudo apt-get update
  - sudo apt-get -y install vim vim-gtk ctags vim-doc vim-scripts cscope ttf-dejavu indent
...

###############################################################################
# start this up
###############################################################################
initialize($vim_conf);

__END__

No futher.
