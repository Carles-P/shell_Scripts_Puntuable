if [ ! -f $1 ]; then
    read -p "El fichero no existe. Por favor, introduzca fichero correcto o teclee 'q' para salir: " correcto
    while [[ ! -f $correcto && $correcto != "q" ]]; do
	read -p "El fichero no existe. Por favor, introduzca fichero correcto o teclee 'q' para salir: " correcto
    done
    fichero=$correcto
else
    fichero=$1
fi
if [ $fichero != "q" ]; then
    numGrupos=0
    stringLineas=`cat $fichero | sed "s/ /\n/g"`
    for i in $stringLineas; do
	if [[ `echo "$i" | grep ":"` ]]; then
	    numGrupos=`expr $numGrupos + 1`
	    echo "$i" > grupo${numGrupos}.txt
	else echo "$i" >> grupo${numGrupos}.txt
	fi
    done
    echo "En el fichero proporcionado tenemos $numGrupos grupos"
    max=0
    for i in `seq 1 $numGrupos`; do
	fichero=`cat grupo${i}.txt`
	numUsuarios=0
	for j in $fichero; do
	    if [[ `echo "$j" | grep ":"` ]]; then
		grupo=`echo "$j"`
	    else
		numUsuarios=`expr $numUsuarios + 1`
	    fi
	done
	echo "$grupo $numUsuarios usuarios"
	if [[ $numUsuarios -gt $max ]]; then
	    max=$numUsuarios
	    echo "$grupo" | sed "s/://" > maxGrupo.txt
	    numGrpMayor=1
	elif [[ $numUsuarios -eq $max ]]; then
	    echo "$grupo" | sed "s/://" >> maxGrupo.txt
	    numGrpMayor=`expr $numGrpMayor + 1`
	fi
	rm grupo${i}.txt
    done
    if [[ $numGrpMayor = 1 ]]; then
	echo "El grupo que tiene más usuarios es `cat maxGrupo.txt`"
    else
	gruposMultiples=""
	contador=0
	for i in `cat maxGrupo.txt`; do
	    contador=`expr $contador + 1`
	    if [[ $contador -eq $numGrpMayor ]]; then
		gruposMultiples="${gruposMultiples}${i}"
	    elif [[ $contador -lt `expr $numGrpMayor - 1` ]]; then
		gruposMultiples="${gruposMultiples}${i}, "
	    else gruposMultiples="${gruposMultiples}${i} y "
	    fi
	done
	echo "Los grupos que tienen más usuarios son $gruposMultiples"
    fi
    rm maxGrupo.txt
else echo "Finalizando..."
fi
