#!/bin/bash
sudo apt-get build-dep vim
wget http://ftp.vim.org/pub/vim/unix/vim-8.2.tar.bz2
aunpack vim-8.2.tar.bz2
cd vim82
 ./configure --prefix=$HOME/.local --enable-pythoninterp=yes
make install