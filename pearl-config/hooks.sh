post_install() {
    info "Applying dotfile for ideavim in ${HOME}/.ideavimrc"
    apply "source ${PEARL_PKGDIR}/ideavimrc" "${HOME}/.ideavimrc"

    # Create the vim dotfiles and spell directories
    mkdir -p ${HOME}/.vim/spell

    if ask "Do you want to setup gvimrc too?" "N"
    then
        setup_configuration "${PEARL_PKGVARDIR}/gvimrc" \
            _new_gvimrc _apply_gvimrc _unapply_gvimrc
    fi
    return 0
}

post_update() {
    post_install
}

pre_remove() {
    _unapply_gvimrc
    unapply "source ${PEARL_PKGDIR}/ideavimrc" "${HOME}/.ideavimrc"
}

_new_gvimrc() {
    if osx_detect
    then
        if command -v fc-list &> /dev/null
        then
            warn "You need to have fontconfig installed. Run: brew install fontconfig"
        fi
    fi

    local fontlist=()
    IFS=$'\n'
    # Disable pipefail as this may fail if list of fonts is empty
    set +o pipefail
    for font in $(fc-list | grep -E "^/(home|Users)" | grep -i mono | cut -d: -f2 | sort -u)
    do
        fontlist+=("$font")
    done
    set -o pipefail

    if [[ -z $fontlist ]]
    then
        error "Fail on setting the font name. You need to install a font first!"
        return 1
    fi

    local fontname=$(choose "Which mono font would you like (for full list run fc-list)?" "${fontlist[0]}" "${fontlist[@]}" | sed  -e 's/^[[:space:]]*//' -e 's/ /\\\\ /g')
    local fontsize=$(input "Which font size would you like?" "18")
    if osx_detect
    then
        local fontsep=":h"
    else
        local fontsep="\\\ "
    fi
    sed -e "s/<FONTSEP>/$fontsep/g" -e "s/<FONTNAME>/$fontname/g" -e "s/<FONTSIZE>/$fontsize/g" "$PEARL_PKGDIR/gvimrc-template" > "$PEARL_PKGVARDIR/gvimrc"

    return 0
}

_apply_gvimrc() {
    apply "source ${PEARL_PKGVARDIR}/gvimrc" $HOME/.gvimrc
}

_unapply_gvimrc() {
    unapply "source ${PEARL_PKGVARDIR}/gvimrc" $HOME/.gvimrc
    return 0
}

