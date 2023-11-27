#! /bin/bash

#added sleep, when run back-to-back sometimes the second one is ignored
sleep 1
rfkill block bluetooth
sleep 1
rfkill block wifi