alias tryhackme="sudo openvpn --config ~/Documents/chandler.scott.m.ovpn > /dev/null 2>&1 &"
alias rustscan='docker run -it --rm --name rustscan rustscan/rustscan:2.1.1'
alias get_ports='rustscan -a 10.10.34.3 | grep Open | awk -F " " '\''{print $2}'\'' > open_ports.txt'

