#!/bin/sh

request() {
    method=${1}
    url=${2}
    expected_http_status=${3}
    parameters=${4}
    if [ -z "${parameters}" ]
    then
        echo "curl -X ${method} -o /dev/null -s -w "%{http_code}\n" --header 'Accept: application/json' ${url}"
        http_status=`curl -X ${method} -o /dev/null -s -w "%{http_code}\n" --header 'Accept: application/json' ${url}`
    else
        echo "curl -X ${method} -d ${parameters} -o /dev/null -s -w "%{http_code}\n" --header 'Accept: application/json' ${url}"
        http_status=`curl -X ${method} -d ${parameters} -o /dev/null -s -w "%{http_code}\n" --header 'Accept: application/json' ${url}`
    fi
    if [ ${http_status} != ${expected_http_status} ]
    then
        echo "${method} ${url} ${parameters} ${http_status} while expecting ${expected_http_status}"
        exit 1
    fi
}

get() {
    request GET ${1} ${2} ${3}
}

post() {
    request POST ${1} ${2} "${3}"
}

put() {
    request PUT ${1} ${2} ${3}
}

delete() {
    request DELETE ${1} ${2} ${3}
}

put http://localhost:3000/associations/1 200 "idUsers[]=4&idUsers[]=3&idUsers[]=1&name=Assoc1"