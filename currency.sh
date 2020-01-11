#!/bin/bash

#IF CURL NOT INSTALLED, INSTALL IT.

curl --version >/dev/null || sudo apt-get --assume-yes install curl >/dev/null

curl -silent https://free.currconv.com/api/v7/convert\?q\=USD_BRL\&compact\=ultra\&apiKey\=26afa0acb3633179cb0b > currency.txt

echo | cat currency.txt | grep date

echo ""

echo | cat currency.txt | grep {

exit
