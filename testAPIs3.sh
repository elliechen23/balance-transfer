#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi

starttime=$(date +%s)

# Print the usage message
function printHelp () {
  echo "Usage: "
  echo "  ./testAPIs2.sh -l golang|node"
  echo "    -l <language> - chaincode language (defaults to \"golang\")"
}
# Language defaults to "golang"
LANGUAGE="golang"

# Parse commandline args
while getopts "h?l:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    l)  LANGUAGE=$OPTARG
    ;;
  esac
done

##set chaincode path
function setChaincodePath(){
	LANGUAGE=`echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]'`
	case "$LANGUAGE" in
		"golang")
		CC_SRC_PATH="github.com/cgschaincode"
		;;
		"node")
		CC_SRC_PATH="$PWD/artifacts/src/github.com/cgschaincode"
		;;
		*) printf "\n ------ Language $LANGUAGE is not supported yet ------\n"$
		exit 1
	esac
}

setChaincodePath

echo "1.POST request Enroll on Org1  ..."
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Jim&orgName=Org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $ORG1_TOKEN"
echo
echo "2.POST request Enroll on Org2 ..."
echo
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Barry&orgName=Org2')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG2 token is $ORG2_TOKEN"
echo
echo

echo "第一組實驗案例-自行DVP"
echo "3.自行DVP交易：BANK002-A07106-券轉出100000"
echo
TRX_ID1=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000001" , "002000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID1"
echo
echo

echo "4.自行DVP交易：BANK002-A07106-券轉入100000"
echo
TRX_ID2=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","002000000002" , "002000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID2"
echo
echo

echo "5.自行DVP交易：BANK004-A07106-券轉出100000"
echo
TRX_ID3=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","004000000001" , "004000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID3"
echo
echo

echo "6.自行DVP交易：BANK004-A07106-券轉入100000"
echo
TRX_ID4=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000002" , "004000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID4"
echo
echo

echo "7.自行DVP交易：BANK005-A07106-券轉出100000"
echo
TRX_ID5=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000001" , "005000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID5"
echo
echo

echo "8.自行DVP交易：BANK005-A07106-券轉入100000"
echo
TRX_ID6=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","005000000002" , "005000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID6"
echo
echo

echo "第二組實驗案例-自行FOP"
echo "9.自行FOP交易：BANK002-A07106-券轉出100000"
echo
TRX_ID7=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000002" , "002000000001" , "A07106" , "0","100000","true"]
}')
echo "Transacton ID is $TRX_ID7"
echo
echo

echo "10.自行FOP交易：BANK004-A07106-券轉入100000"
echo
TRX_ID8=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","002000000001" , "002000000002" , "A07106" , "0","100000","true"]
}')
echo "Transacton ID is $TRX_ID8"
echo
echo

echo "11.自行FOP交易：BANK004-A07106-券轉出100000"
echo
TRX_ID9=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","004000000002" , "004000000001" , "A07106" , "0","100000","true"]
}')
echo "Transacton ID is $TRX_ID9"
echo
echo

echo "12.自行FOP交易：BANK004-A07106-券轉入100000"
echo
TRX_ID10=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000001" , "004000000002" , "A07106" , "0","100000","true"]
}')
echo "Transacton ID is $TRX_ID10"
echo
echo

echo "13.自行FOP交易：BANK005-A07106-券轉出100000"
echo
TRX_ID11=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000002" , "005000000001" , "A07106" , "0","100000","true"]
}')
echo "Transacton ID is $TRX_ID11"
echo
echo

echo "14.自行FOP交易：BANK005-A07106-券轉入100000"
echo
TRX_ID12=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","005000000001" , "005000000002" , "A07106" , "0","100000","true"]
}')
echo "Transacton ID is $TRX_ID12"
echo
echo

echo "第三組實驗案例-跨行DVP-成功"
echo "15.設定同資旗標=0(自動比對Finished)"
echo
TRX_ID13=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"put",
	"args":["approveflag" , "0"]
}')
echo "Transacton ID is $TRX_ID13"
echo
echo

echo "16.跨行DVP交易：BANK002-BANK004-A07106-券轉出100000-款轉入102000"
echo
TRX_ID14=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000001" , "004000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID14"
echo
echo

echo "17.跨行DVP交易：BANK004-BANK002-A07106-券轉入100000-款轉出102000"
echo
TRX_ID15=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000001" , "002000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID15"
echo
echo

echo "18.跨行DVP交易：BANK004-BANK005-A07106-券轉出100000-款轉入102000"
echo
TRX_ID16=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","004000000001" , "005000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID16"
echo
echo

echo "19.跨行DVP交易：BANK005-BANK004-A07106-券轉入100000-款轉出102000"
echo
TRX_ID17=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","005000000001" , "004000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID17"
echo
echo

echo "20.跨行DVP交易：BANK005-BANK002-A07106-券轉出100000-款轉入102000"
echo
TRX_ID18=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000001" , "002000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID18"
echo
echo

echo "21.跨行DVP交易：BANK002-BANK005-A07106-券轉入100000-款轉出102000"
echo
TRX_ID19=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","002000000001" , "005000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID19"
echo
echo

echo "第四組實驗案例-跨行DVP-等待回應"
echo "第六組實驗案例-跨行DVP-等待回應-交易放行"
echo "22.設定同資旗標=1(等同資回應Waiting4Payment)"
echo
TRX_ID20=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"put",
	"args":["approveflag" , "1"]
}')
echo "Transacton ID is $TRX_ID20"
echo
echo


echo "23.跨行DVP交易：BANK002-BANK004-A07106-券轉出100000-款轉入102000"
echo
TRX_ID21=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000002" , "004000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID21"
echo
echo

echo "24.跨行DVP交易：BANK004-BANK002-A07106-券轉入100000-款轉出102000"
echo
TRX_ID22=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000002" , "002000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID22"
echo
echo

echo "25.跨行DVP交易：BANK004-BANK005-A07106-券轉出100000-款轉入102000"
echo
TRX_ID23=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","004000000002" , "005000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID23"
echo
echo

echo "26.跨行DVP交易：BANK005-BANK004-A07106-券轉入100000-款轉出102000"
echo
TRX_ID24=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","005000000002" , "004000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID24"
echo
echo

echo "27.跨行DVP交易：BANK005-BANK002-A07106-券轉出100000-款轉入102000"
echo
TRX_ID25=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000002" , "002000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID25"
echo
echo

echo "28.跨行DVP交易：BANK002-BANK005-A07106-券轉入100000-款轉出102000"
echo
TRX_ID26=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","002000000002" , "005000000002" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID26"
echo
echo

echo "第五組實驗案例-跨行DVP-款不足"
echo "第七組實驗案例-跨行DVP-款不足-交易取消"
echo "29.設定同資旗標=2(PaymentError)"
echo
TRX_ID27=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"put",
	"args":["approveflag" , "2"]
}')
echo "Transacton ID is $TRX_ID27"
echo
echo

echo "30.跨行DVP交易：BANK002-BANK004-A07106-券轉出100000-款轉入102000"
echo
TRX_ID28=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000001" , "004000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID28"
echo
echo

echo "31.跨行DVP交易：BANK004-BANK002-A07106-券轉入100000-款轉出102000"
echo
TRX_ID29=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000001" , "002000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID29"
echo
echo

echo "32.跨行DVP交易：BANK004-BANK005-A07106-券轉出100000-款轉入102000"
echo
TRX_ID30=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","004000000001" , "005000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID30"
echo
echo

echo "33.跨行DVP交易：BANK005-BANK004-A07106-券轉入100000-款轉出102000"
echo
TRX_ID31=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","005000000001" , "004000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID31"
echo
echo

echo "34.跨行DVP交易：BANK005-BANK002-A07106-券轉出100000-款轉入102000"
echo
TRX_ID32=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000001" , "002000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID32"
echo
echo

echo "35.跨行DVP交易：BANK002-BANK005-A07106-券轉入100000-款轉出102000"
echo
TRX_ID33=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","002000000001" , "005000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID33"
echo
echo

echo "36.設定同資旗標=5(自動比對券款)"
echo
TRX_ID34=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"put",
	"args":["approveflag" , "5"]
}')
echo "Transacton ID is $TRX_ID34"
echo
echo

echo "第八組實驗案例-跨行DVP-交易面額輸錯"
echo "第十二組實驗案例-跨行DVP-交易面額輸錯-交易更正"
echo "37.跨行DVP交易面額輸錯：BANK002-BANK004-A07106-券轉出101000-款轉入102000"
echo
TRX_ID35=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000001" , "004000000001" , "A07106" , "102000","101000","true"]
}')
echo "Transacton ID is $TRX_ID35"
echo
echo

echo "38.跨行DVP交易面額打錯：BANK004-BANK002-A07106-券轉入100000-款轉出102000"
echo
TRX_ID36=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000001" , "002000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID36"
echo
echo


echo "第九組實驗案例-跨行DVP-交易金額輸錯"
echo "第十三組實驗案例-跨行DVP-交易金額輸錯-交易更正"
echo "39.跨行DVP交易金額打錯：BANK005-BANK004-A07106-券轉出100000-款轉入102000"
echo
TRX_ID37=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000001" , "004000000001" , "A07106" , "102000","100000","true"]
}')
echo "Transacton ID is $TRX_ID37"
echo
echo

echo "40.跨行DVP交易金額打錯：BANK004-BANK005-A07106-券轉入100000-款轉出101000"
echo
TRX_ID38=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["B","004000000001" , "005000000001" , "A07106" , "101000","100000","true"]
}')
echo "Transacton ID is $TRX_ID38"
echo
echo

echo "第十組實驗案例-跨行DVP-賣方券不足"
echo "41.跨行DVP交易券不足：BANK005-BANK002-A07106-券轉出10000000-款轉入102000"
echo
TRX_ID39=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","005000000001" , "002000000001" , "A07106" , "103000","10000000","true"]
}')
echo "Transacton ID is $TRX_ID39"
echo
echo

echo "第十組實驗案例-跨行DVP-買方款不足"
echo "42.跨行DVP交易款不足：BANK002-BANK005-A07106-券轉出100000-款轉入10200000"
echo
TRX_ID40=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"securityTransfer",
	"args":["S","002000000001" , "005000000001" , "A07106" , "10200000","103000","true"]
}')
echo "Transacton ID is $TRX_ID40"
echo
echo

echo "第十四組實驗案例-利息計算與配息"
echo "43.公債利息更新A07106-2019/06/02應計利息試算"
echo
TRX_ID41=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"updateOwnerInterest",
	"args":["A07106","20190602"]
}')
echo "Transacton ID is $TRX_ID41"
echo
echo


echo "44.公債利息更新A07106-BANK002-2019/06/02應計利息試算"
echo
TRX_ID42=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"changeBankSecurityTotals",
	"args":["A07106","002","20190602"]
}')
echo "Transacton ID is $TRX_ID42"
echo
echo

echo "45.公債利息更新A07106-BANK004-2019/06/02應計利息試算"
echo "POST invoke chaincode on peers of Org1"
echo
TRX_ID43=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"changeBankSecurityTotals",
	"args":["A07106","004","20190602"]
}')
echo "Transacton ID is $TRX_ID43"
echo
echo

echo "46.公債利息更新A07106-BANK005-2019/06/02應計利息試算"
echo "POST invoke chaincode on peers of Org1"
echo
TRX_ID44=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
	"fcn":"changeBankSecurityTotals",
	"args":["A07106","005","20190602"]
}')
echo "Transacton ID is $TRX_ID44"
echo
echo



echo "47.readBank BANK002"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readBank&args=%5B%22BANK002%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "48.readBank BANK004"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readBank&args=%5B%22BANK004%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "49.readBank BANK005"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readBank&args=%5B%22BANK005%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "50.readBank BANKCBC"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readBank&args=%5B%22BANKCBC%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "51.readAccount 002000000001"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readAccount&args=%5B%22002000000001%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "52.readAccount 002000000002"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readAccount&args=%5B%22002000000002%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "53.readAccount 004000000001"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readAccount&args=%5B%22004000000001%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "54.readAccount 004000000002"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readAccount&args=%5B%22004000000002%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "55.readAccount 005000000001"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readAccount&args=%5B%22005000000001%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "56.readAccount 005000000002"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=readAccount&args=%5B%22005000000002%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "57.querySecurity A07106"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=querySecurity&args=%5B%22A07106%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "58.queryAllTransactions"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=queryAllTransactions&args=%5B%22BK002%22%2C%22BK006%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "59.queryAllQueuedTransactions"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=queryAllQueuedTransactions&args=%5B%2220180611%22%2C%2220181231%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "60.queryAllHistoryTransactions"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=queryAllHistoryTransactions&args=%5B%22H20180611%22%2C%22H20181231%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "61.同資旗標：approveflag"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=get&args=%5B%22approveflag%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

############################################################################

echo "62.GET query Block by blockNumber"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/blocks/1?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "63.GET query Transaction by TransactionID"
echo
curl -s -X GET http://localhost:4000/channels/mychannel/transactions/$TRX_ID16?peer=peer0.org1.example.com \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

############################################################################
### TODO: What to pass to fetch the Block information
############################################################################
#echo "GET query Block by Hash"
#echo
#hash=????
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel/blocks?hash=$hash&peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "cache-control: no-cache" \
#  -H "content-type: application/json" \
#  -H "x-access-token: $ORG1_TOKEN"
#echo
#echo

echo "64.GET query ChainInfo"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "65.GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "66.GET query Instantiated chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "67.GET query Channels"
echo
curl -s -X GET \
  "http://localhost:4000/channels?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "Total #67 execution time : $(($(date +%s)-starttime)) secs ..."
