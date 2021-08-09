#!/bin/bash
BOOTDIR="./bootnode.txt"
OUTPUTLOG="./cypherlog.txt"
LOGLEVEL=4
bootnode_addr=cnode://"$(grep cnode $BOOTDIR|tail -n 1|awk -F '://' '{print $2}')"

IPENCDISVALUE=1
CONSOLEMODE="--console"
BACKENDMODE="--backend"
CLIMODE=$CLISILENTMODE

if [[ "$1" != "" ]];then
   CLIMODE=$1
fi

ostype()
{
  osname=`uname -s`
 # echo "osname $osname"
  OSTYPE=UNKNOWN
  case $osname in
     "FreeBSD") OSTYPE="freebsd"
     ;;
     "SunOS") OSTYPE="solaris"
     ;;
     "Linux") OSTYPE="linux"
     ;;
     "Darwin") OSTYPE="darwin"
     ;;
     "linux") OSTYPE="linux"
     ;;
     "darwin") OSTYPE="darwin"
     ;;
     *) echo "other system $osname"
     ;;
    esac
  return 0

}
ostype
CHAINDB="./$OSTYPE/chaindb"
BINDIR="./$OSTYPE/cypher"
RNET_PORT=7100
P2P_PORT=6000
RPC_PORT=8000
select=$2
if [[ "$select" == "test" ]];then
        BINDIR="./$OSTYPE/cyphertest"
        CHAINDB="./$OSTYPE/chaindbtest"
        OUTPUTLOG="cypherlogtest.txt"
        RNET_PORT=7102
        P2P_PORT=6002
        RPC_PORT=8002
fi

echo "CHAINDB $CHAINDB"
echo "BINDIR $BINDIR"
killall -9 cypher
killall -9 cyphertest
NetWorkId=`less genesis.json|awk -F "[:]" '/chainId/{print $2}'`
NetWorkId=`echo $NetWorkId | cut -d \, -f 1`
ip=`curl icanhazip.com`
echo "ip: $ip"
echo "bootnode address: $bootnode_addr"
echo "Client print mode:$CLIMODE,please wait for some seconds!"
if [[ "$CLIMODE" == "$CLISILENTMODE" || "$CLIMODE" == "0" || "$CLIMODE" == " " ]];then
   nohup $BINDIR --nat=extip:$ip --ws   -wsaddr="0.0.0.0" --wsorigins "*" --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --rpcapi cph,web3c,personal,miner,txpool,net --rnetport $RNET_PORT --port $P2P_PORT --rpcport $RPC_PORT --verbosity $LOGLEVEL --datadir $CHAINDB --networkid $NetWorkId --gcmode archive --bootnodes $bootnode_addr   > "$OUTPUTLOG" 2>&1 &
else
         $BINDIR --nat=extip:$ip --ws   -wsaddr="0.0.0.0" --wsorigins "*" --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --rpcapi cph,web3c,personal,miner,txpool,net --rnetport $RNET_PORT --port $P2P_PORT --rpcport $RPC_PORT --verbosity $LOGLEVEL --datadir $CHAINDB --networkid $NetWorkId --gcmode archive --bootnodes "$bootnode_addr" console
fi

