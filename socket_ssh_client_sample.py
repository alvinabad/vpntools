#!/usr/bin/env python

import socket
import ssh2.session
import sys

if __name__ == '__main__':
    try:
        host = sys.argv[1]
        username = sys.argv[2]
        password = sys.argv[3]
    except IndexError:
        print("Usage: %s host username password" % os.path.basename(sys.argv[0]))
        sys.exit(1)

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((host, 22))

    session = ssh2.session.Session()
    session.handshake(sock)
    session.userauth_password(username,password)

    channel = session.open_session()
    channel.execute('vts cliadmin')
    size, data = channel.read()
    while size > 0:
        print(data.decode())
        size, data = channel.read()
        print("--------------------")
    channel.close()

    print("Exit status: {0}".format(channel.get_exit_status()))
