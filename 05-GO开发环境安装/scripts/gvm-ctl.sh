#!/usr/bin/env bash


install_requirements() {
    yum install -y curl git make bison gcc glibc-devel
}

install_gvm() {
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
}

install_go() {
    usage="
    Usage: gvm install [version] [options]
    -s,  --source=SOURCE      Install Go from specified source.
    -n,  --name=NAME          Override the default name for this version.
    -pb, --with-protobuf      Install Go protocol buffers.
    -b,  --with-build-tools   Install package build tools.
    -B,  --binary             Only install from binary.
         --prefer-binary      Attempt a binary install, falling back to source.
    -h,  --help               Display this message.
    "
    if [ $1 ]; then
        gvm install go1.4 -B
        gvm use go1.4
        export GOROOT_BOOTSTRAP=$GOROOT
        gvm install go$1 -B
    else
        echo $usage
    fi
}


main() {
    if [ -f /root/.gvm/scripts/gvm ]; then
        source /root/.gvm/scripts/gvm
    fi

    case "$1" in 
        install-gvm)
        install_requirements
        install_gvm
        ;;

        install-go)
        install_go $2
        ;;

        use-go)
        gvm use go$2
        ;;

        list)
        gvm list
        ;;

        listall)
        gvm listall
        ;;

        uninstall)
        gvm implode
        ;;

        *)
        usage="
        Usage:
             \t $0 install-gvm        \n
             \t $0 listall            \n
             \t $0 install-go 1.17    \n
             \t $0 list               \n
             \t $0 uninstall          \n
        " 
        echo -e $usage
        ;;

    esac    
}

main $@
