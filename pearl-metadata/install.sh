
post_install() {
    apply "source $PEARL_PKGDIR/vimrc" $HOME/.vimrc
}

pre_remove() {
    unapply "source $PEARL_PKGDIR/vimrc" $HOME/.vimrc
}
