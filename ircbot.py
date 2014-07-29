#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import json, os, re, socket, sys, time

class IRCBot:
    sock = None
    auto_reconnect = False
    irc_channels = {}

    config = {  'host': 'chat.freenode.net',
                'port': 6667,
                'nick': '_Berry-Punch_',
                'auth': False,
                'recvsize': 4096,
                'partmessage': 'Bye bye !',
                'autojoin': ['#test_berrypunch']}

    def test(self):
        """Run the irc bot"""
        self._loadcfg()
        self.connect()
        
        time.sleep(5)
        for chan in self.config['autojoin']:
            self.send('PRIVMSG {0} :Salut tout le monde !\r\n'.format(chan))

        time.sleep(2)
        self.part()
        self.close()

    # -------------------------------------------------------------------------
    #                           Configuration load/save
    # -------------------------------------------------------------------------
    def _loadcfg(self):
        """Loads the configuration file"""
        if not os.path.isfile('config.json'):
            self._savecfg()

        with open('config.json', 'r') as cfgHandle:
            self.config = json.load(cfgHandle)

    def _savecfg(self):
        """Saves the actual configuration"""
        with open('config.json', 'w') as cfgHandle:
            json.dump(self.config, cfgHandle)

    # -------------------------------------------------------------------------
    #                            Connection management
    # -------------------------------------------------------------------------
    def connect(self):
        """Connects to the irc server"""
        if self.sock != None:
            self.sock.detach()
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        
        self.sock.connect( (self.config['host'], self.config['port']) )

        if not self.sock._closed:
            self.identify()

    def close(self):
        """Close an active connection to IRC"""
        if self.sock._closed == True:
            raise BaseException('Connection already closed')

        self.send('QUIT\r\n')
        self.log(self.read())
        self.sock.detach()

    def identify(self):
        """Identify to IRC: gives our nickname and join channels specified in autojoin config"""
        if self.sock._closed == True:
            raise BaseException('Socket closed, cannot identify')

        self.send('USER IRCBot None None :{0}\r\nNICK {0}\r\n'.format(self.config['nick']))

        self.log(self.read())

        for channel in self.config['autojoin']:
            self.send('JOIN {0}\r\n'.format(channel))
            self.log(self.read())
            self.irc_channels[channel] = True

    def part(self, channel=''):
        """Quit from a channel"""
        if self.sock._closed:
            raise BaseException('Socket closed, cannot part from channel(s)')

        if channel == '':
            for channel_item in self.irc_channels.keys():
                self.send('PART {partchan} :{partmsg}\r\n'.format(partchan=channel_item, partmsg=self.config['partmessage']))
                self.log(self.read())

        if channel in self.irc_channels.keys():
            self.send('PART {partchan} :{partmsg}\r\n'.format(partchan=channel, partmsg=self.config['partmessage']))
            self.log(self.read())

    # -------------------------------------------------------------------------
    #                               Communications
    # -------------------------------------------------------------------------
    def send(self, data):
        """Send data to server"""
        self.sock.send(str.encode(data))

    def read(self):
        """Read data from server"""
        return self.sock.recv(self.config['recvsize'])

    def read_nolock(self):
        """Read data from server, without being locked"""
        data = ""
        self.sock.settimeout(0.1)

        try:
            while True:
                data += self.read()
        except:
            e = sys.exc_info()[0]
            if e.__name__ != 'timeout':
                self.log('ERROR: ' + e.__name__)

        self.sock.settimeout(None)
        return data

    # -------------------------------------------------------------------------
    #                                 Exec trace
    # -------------------------------------------------------------------------
    def log(self, data):
        """Log everything to the terminal"""
        for line in data.splitlines():
            sys.stdout.write('[ircbot] {0}\n'.format(line))
        sys.stdout.flush()

    # -------------------------------------------------------------------------
    #                                Main routines
    # -------------------------------------------------------------------------
    def ping(self, strtosend=''):
        """Answers to server's pings"""
        self.send('PONG {0}\r\n'.format(strtosend))

    def call(self):
        while not self.sock._closed:
            text = self.read()
            for line in text.splitlines():
                # handle text types with regexps
                pass
