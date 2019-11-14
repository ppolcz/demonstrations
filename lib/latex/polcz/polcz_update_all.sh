while IFS= read -r line
do
    echo "$line"
    meld "/home/ppolcz/_/2_demonstrations/lib/latex/polcz/polcz.sty" "$line"
done < <(find ${HOME} | egrep polcz.sty)

