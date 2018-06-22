#!/bin/sh


# MIT License

# Copyright (c) [2017] [Harvey Cary]

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

SCRIPTNAME=$0

status_chk() {

  while :
  do
    sudo ipsec status
    echo "Do something; hit [CTRL+C] to stop!"
    sleep 10
  done
  
}



mode=`sudo nordvpn.py --getmode`

case "$1" in
    --up)
        #echo sudo ./nordvpn-ike.py $@
        sudo nordvpn.py $@
        echo "Exit status " $?
        sleep 1
        case $mode in
          ikev2)
            sudo ipsec restart
            echo "Exit status " $?
            sleep 1
            sudo ipsec up NordVPN
            echo "Exit status " $?
            sleep 1
            ;;
          openvpn)
            sudo openvpn --config /etc/nordvpn.ovpn
            sleep 1
            ;;
        esac
        curl ipinfo.io
        ;;
        
    --down)
      case $mode in
        ikev2)
          sudo ipsec down NordVPN
          echo "Exit status " $?
          sleep 1
          ;;
        openvpn)
          sudo ipsec down NordVPN
          sleep 1
          ;;
        esac
        sleep 1
        curl ipinfo.io
        ;;
        
    status)
        status_chk
        ;;
        
    *)
        echo "Usage: $SCRIPTNAME {start|stop|status}" >&2
        exit 3
        ;;
esac

exit 0
