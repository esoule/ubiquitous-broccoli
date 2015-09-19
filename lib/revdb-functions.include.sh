
show_error()
{
    echo "$@" >&2
}

revdb_read_exactly_one_word()
{
    { tr '\012' ' ' | sed -e 's/[ \r\n\t\|]\+/ /g;s/^\s\+//;s/\s\+$//;' | grep -E '^[A-Za-z0-9_+-]+$' ; } || :
    return 0
}

revdb_read_exactly_one_number()
{
    { tr '\012' ' ' | sed -e 's/[ \r\n\t\|]\+/ /g;s/^\s\+//;s/\s\+$//;' | grep -E '^[0-9]+$' ; } || :
    return $?
}

revdb_read_exactly_one_line()
{
    { tr '\012' ' ' | sed -e 's/[ \r\n\t\|]\+/ /g;s/^\s\+//;s/\s\+$//;' ; } || :
    return 0
}

revdb_get_subdir()
{
    local subdir1=$(echo -n "$1" | sha1sum -b | cut -d ' ' -f 1 | grep -E -o '^[0-9A-Fa-f]{2}')
    echo "objects/${subdir1}/$1"
    return 0
}

revdb_number_init()
{
    local serial="$1"
    if [ -z "${serial}" ] ; then
        return 1
    fi
    echo "${serial}" >./serial.txt.new
    cp --archive ./serial.txt.new ./serial.txt.old
    mv ./serial.txt.new ./serial.txt
    echo "${serial}"
    return 0
}

revdb_number_get_and_incr()
{
    if [ ! -r ./serial.txt ] ; then
        return 1
    fi
    local serial="$(cat ./serial.txt | revdb_read_exactly_one_number)"
    if [ -z "${serial}" ] ; then
        return 1
    fi
    cp --archive ./serial.txt ./serial.txt.old
    local nextserial=$((serial + 1))
    echo "${nextserial}" >./serial.txt.new
    mv ./serial.txt.new ./serial.txt
    echo "${serial}"
    return 0
}

