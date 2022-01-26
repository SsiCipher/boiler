#!/bin/bash

BIN="$HOME/bin";

install(){
  if [[ ! -e "$BIN" ]]; then
    mkdir $BIN;
    export PATH="$PATH:$BIN";
  fi

  if [[ -e "$BIN/boiler" ]]; then
    rm $BIN/boiler;
    echo "🗑 Delete old boiler ! ";
  fi
  chmod 755 boiler.sh;
  cp ./boiler.sh $BIN/boiler;
  
  echo "✅ Boiler installed successfuly !";

}

install ;
