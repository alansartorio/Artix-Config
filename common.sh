
RED='\033[1;34m'
NC='\033[0m' # No Color

info () {
  printf "${RED}$1${NC}\n"
}

pauseInfo () {
    info "$1\nPress return to continue..."
    read
}