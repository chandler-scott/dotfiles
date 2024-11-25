# Common
alias python="python3"
alias md2pdf='python $SCRIPTS/md2pdf.py'
alias ccat="pygmentize -O style=dracula -g"
alias discord="discord > /dev/null 2>&1 &"
alias chrome="google-chrome > /dev/null 2>&1 &"
alias view="gio open"
alias archive="tar -czf"

# VPNs
alias vpn-etsu="/opt/cisco/anyconnect/bin/vpnui"
alias tryhackme="sudo openvpn --config $HOME/.vpns/chandler.scott.m.ovpn"

# Tools
alias rustscan="docker run -it --rm --name rustscan rustscan/rustscan:2.1.1"
