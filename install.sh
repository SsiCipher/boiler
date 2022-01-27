#!/bin/bash

BIN="$HOME/bin";
BOILER_PROJS_DIR="";

config(){
  
  echo -n "Absolut path to your projects directory : ";
  read dir;
  echo "dir : $dir";
  if [[ ! -e $dir ]]; then
    echo "⚠️  Directory not found !";
  else
    export BOILER_PROJS_DIR=$dir;
  fi
}

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

config ;
install ;
