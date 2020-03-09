#!/usr/bin/bash


#Created: 2020-01-11
#Author: RaphaelSilv
#Modified: 2020-02-01
#By: RaphaelSilv
#
#Under public Domain


#Global variables

declare VERSION="0.1.0"
declare amount
declare AMOUNT
declare DATE
declare FROM_CURRENCY
declare from_currency
declare TO_CURRENCY
declare to_currency
declare CURRENCY_VALUE
declare -r API_KEY="26afa0acb3633179cb0b"

CURRENCIES=(aed afn all amd ang aoa ars aud awg azn bam bbd bdt bgn bhd bif
bmd bnd bob brl bsd btc btn bwp byn byr bzd cad cdf chf clf clp cny cop crc cuc
cup cve czk djf dkk dop dzd egp ern etb eur fjd fkp gbp gel ggp ghs gip gmd gnf
gtq gyd hkd hnl hrk htg huf idr ils imp inr iqd irr isk jep jmd jod jpy kes kgs
khr kmf kpw krw kwd kyd kzt lak lbp lkr lrd lsl lvl lyd mad mdl mga mkd mmk mnt
mop mro mur mvr mwk mxn myr mzn nad ngn nio nok npr nzd omr pab pen pgk php pkr
pln pyg qar ron rsd rub rwf sar sbd scr sdg sek sgd shp sll sos srd std svc syp
szl thb tjs tmt tnd top try ttd twd tzs uah ugx usd uyu uzs vef vnd vuv wst xaf
xag xcd xdr xof xpf yer zar zmk zmw zwl)

function main {

    if [ -z "${from_currency}" ] && [ -z "${to_currency}" ] && [ -z "${amount}" ]
    then
        help_func
    elif [ -n "${to_currency}" ] && [ -n "${to_currency}" ] && [ -n "${amount}" ]
    then
        currency_validation
        get_currencies
    else
        echo "You must to provide a valid argument."
    fi
}


function currency_validation {

    for i in "${CURRENCIES[@]}";
    do
        if [[ "$to_currency" == "$i" ]];
        then
            TO_CURRENCY=$( echo "$to_currency" | tr '[:lower:]' '[:upper:]' )
        elif [[ "$from_currency" == "$i" ]];
        then
            FROM_CURRENCY=$( echo "$from_currency" | tr '[:lower:]' '[:upper:]' )
        fi
    done
}

function get_currencies {

    CURRENCY_ID="${FROM_CURRENCY}""_""${TO_CURRENCY}"

    curl -silent https://free.currconv.com/api/v7/convert\?q\=${CURRENCY_ID}\&compact\=ultra\&apiKey\=${API_KEY} > utils/.requisitions

    CURRENCY_VALUE=$( < utils/.requisitions tr ' ' _ | grep "${CURRENCY_ID}" | grep -E '[0-9]' | tr -d '{}"":A-Z_' )
    DATE=$( < utils/.requisitions tr ' ' ' ' | grep -i date )
    conversor
}




function echo_transaction {

    if [ -z "${FROM_CURRENCY}" ]
    then
        echo "You must to provide a valid argument."
    elif [ -z "${TO_CURRENCY}" ]
    then
         echo "You must to provide a valid argument."
         echo "try curr -h"
    else
        echo "==================================="
        echo -e "${DATE}\n"
        echo "${AMOUNT} ${FROM_CURRENCY} = ${CONVERSOR} ${TO_CURRENCY}"
        echo "==================================="

    fi
}


function conversor {

    if [ "$amount" != "" ]
    then
        if [[ "$amount" =~ [0-9] ]]
        then
            AMOUNT="$amount"
        fi
    fi
    CONVERSOR=$( echo "scale=2; ($CURRENCY_VALUE * $AMOUNT)" | bc -l )
    echo_transaction

}

function help_func {

    echo -e "\n"
    echo -e "Usage: <alias> -f [FROM CURRENCY] -t [TO CURRENCY] -a [AMOUNT]"
    echo -e "Please, try one of the valid arguments bellow\n"
    < utils/.help tr ' ' ' ' | pr -t -1
    echo -e "\n"
    echo "You can find more info in https://github.com/RaphaelSilv/shell-currency-exchange/blob/master/README.org"
}

function get_version {
  echo "shell-currency - $VERSION"
}

while getopts "f:t:a:h" opt;
do
    case $opt in
        t) to_currency="$OPTARG" ;;
        f) from_currency="$OPTARG" ;;
        a) amount="$OPTARG" ;;
        h) help_func >&2 ;;
        *) help_func >&2
           exit 1 ;;
    esac
done
shift $((OPTIND -1))

main "$@"

exit 0
