
BLUE='\033[1;34m'
NC='\033[0m' # No Color

info () {
  printf "${BLUE}%s${NC}\n" "$*"
}

pauseInfo () {
    echo "$@"
    info "$@\nPress return to continue..."
    read
}
option () {
    # printf "$1"
    # read -q
    read -p "$1" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        eval "$2"
    else
        eval "$3"
    fi
}