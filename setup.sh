#!/bin/bash

set -euo pipefail
​
PHASES=()
​
add_phase() {
  PHASES+=("$1")
  read -r "PHASE_NAME_$1" <<< "$2"
}
​
name_of_phase() {
  local namevar
  namevar="PHASE_NAME_${phase}"
  echo "${!namevar}"
}
​
c_tl=┏
c_bl=┗
#c_br=┛
#c_tr=┓
horz=━
vert=┃
​
print_title() {
  local printing written width diff s
  printing="${c_tl}${horz}${horz} $1/$2: $3 "
  width="$(tput cols)"
  written="${#printing}"
  ((diff = width - written))
  s="$(printf "%-${diff}s" "${horz}")"
  s="${s// /${horz}}"
​
  echo -e "\x1b[36m${c_tl}${horz}${horz} \x1b[35m$1/$2: $3 \x1b[36m${s}\x1b[0m"
}
​
print_footer() {
  local width diff s
  width="$(tput cols)"
  ((diff = width - 1))
  s="$(printf "%-${diff}s" "${horz}")"
  s="${s// /${horz}}"
​
  echo -e "\x1b[36m${c_bl}${s}\x1b[0m"
}
​
run_phases() {
  local name current max
​
  current=1
  max=${#PHASES[@]}
​
  for phase in ${PHASES[*]}; do
    name="$(name_of_phase "${phase}")"
    print_title "${current}" "${max}" "${name}"
​
    # indent both stdout and stderr, but make the stderr indentation red instead of cyan.
    {
      {
        {
          ${phase} 8>&2 2>&3 | sed "s/^/\x1b[36m${vert}\x1b[0m /"; 
        } 3>&1 1>&2 | sed "s/^/\x1b[31m${vert}\x1b[0m /"
      } 4>&1 1>&2 | sed "s/^/\x1b[34m${vert}\x1b[0m /"
    } 7>&1 1>&2 | sed "s/^/\x1b[32m${vert}\x1b[0m /"
​
    print_footer
    ((current += 1))
  done
}
​
success() {
  >&7 echo -e "\x1b[32m✓\x1b[0m $1"
}
​
default_clone_path="${HOME}/src/github.com/shopify/shopify"
​
prompt() {
  local path
  >&4 echo -e "\x1b[34m?\x1b[0m $1"
  sync
  2>&8 read -p $'\x1b[34m'${vert}$' > \x1b[0m\x1b[s\x1b[33m' -r path
  if [[ "${path}" == "" ]]; then
    path="${default_clone_path}"
    >&8 echo -e "\x1b[A\x1b[u\x1b[33m${default_clone_path}"
  fi
  echo -en "\x1b[0m"
  answer=$path
}
​
install_homebrew() {
  if [[ -d /usr/local/Cellar ]]; then
    success "It looks like homebrew is already installed."
    return
  fi
  echo "Downloading and running homebrew installer..."
  bash provision/brew.sh
}
​
install_ssh() {
  bash provision/ssh.sh
}
​
install_ruby() {
  if [ $(which ruby) != '/usr/bin/ruby' ]; then
    success "It looks like Ruby is already setup."
    return
  fi

  echo "Installing Ruby..."
  bash provision/rvm.sh
}

install_script() {
  ~/Development/personal/other/dotfiles/install.sh
}
​
main() {
  add_phase install_homebrew "Install Homebrew"
  add_phase install_ssh      "Install SSH"
  add_phase install_ruby     "Install Ruby"
  add_phase install_script   "Run Install Script for Dotfile"
​
  run_phases
}
main "$@"
