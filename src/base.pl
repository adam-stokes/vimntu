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
	my $vimrcafter = catfile($home, ".vimrc.after");
	my $gvimrcafter = catfile($home, ".gvimrc.after");
	foreach (@{$conf->{script}}) {
		print "running: $_\n";
		`$_`;
	}
  local $CWD = catdir($home, '.janus');
	foreach (@{$conf->{plugins}}) {
		`git clone -q $_`;
	}
	write_file($vimrcafter, {binmode => ':raw'}, $conf->{vimrcafter});
	write_file($gvimrcafter, {binmode => ':raw'}, $conf->{gvimrcafter});
}

###############################################################################
# YAML Configuration
###############################################################################
my $vim_conf = YAML::Load << '...';
---
name: vim
description: VIM Text Editor and plugins
vimrcafter: |
  color jellybeans
  set background=dark
  set textwidth=79
  set formatoptions=qrn1
  if exists('+colorcolumn')
    set colorcolumn=80
  endif
  set list
  set listchars=tab:.\ ,trail:.,extends:#,nbsp:.
  set numberwidth=5
  set cursorline
  set cursorcolumn
gvimrcafter: |
  color jellybeans
  if has("gui_running")
    set guifont=Monospace\ 10
    set list
    set listchars=tab:▸\ ,eol:¬,extends:#,nbsp:.,trail:.
    set guioptions-=r
    set go-=L
    set go-=T
  endif
plugins:
  - git://github.com/antono/html.vim
  - git://github.com/bling/vim-airline
  - git://github.com/klen/python-mode
  - git://github.com/nanotech/jellybeans.vim
  - git://github.com/othree/html5.vim
  - git://github.com/rodjek/vim-puppet
  - git://github.com/sickill/vim-pasta
  - git://github.com/tpope/vim-bundler
  - git://github.com/tpope/vim-endwise
  - git://github.com/tpope/vim-eunuch
  - git://github.com/tpope/vim-fugitive
  - git://github.com/tpope/vim-haml
  - git://github.com/tpope/vim-rails
  - git://github.com/tpope/vim-scriptease
  - git://github.com/tpope/vim-sensible
  - git://github.com/tpope/vim-surround
  - git://github.com/vimoutliner/vimoutliner
  - git://github.com/vim-perl/vim-perl
  - git://github.com/vim-ruby/vim-ruby
  - git://github.com/Yggdroot/indentLine
script:
  - sudo apt-get -y install python-software-properties
  - sudo apt-add-repository -y ppa:nmi/vim-snapshots
  - sudo apt-get update
  - sudo apt-get -y install vim vim-gtk git
  - curl -Lo- https://bit.ly/janus-bootstrap | bash
...

###############################################################################
# start this up
###############################################################################
initialize($vim_conf);

__END__

No futher.
