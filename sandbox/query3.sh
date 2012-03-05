#!/bin/bash

lfuzz="0.9"
ufuzz="1.1"

mysql --user="root" --password="" mydb --execute="
        #Crunch Algorithm
        select genus,species,
        (
            ( greatest(ABS($1),ABS(whRatio))		/ least(ABS($1),ABS(whRatio)) ) + 
            ( greatest(ABS($2),ABS(surfaceRatio))		/ least(ABS($2),ABS(surfaceRatio)) ) + 
            ( greatest(ABS($3),ABS(perimeterRatio))		/ least(ABS($3),ABS(perimeterRatio)) ) + 
            ( greatest(ABS($4),ABS(deviationR))		/ least(ABS($4),ABS(deviationR)) ) + 
            ( greatest(ABS($5),ABS(deviationG))		/ least(ABS($5),ABS(deviationG)) ) + 
            ( greatest(ABS($6),ABS(deviationB))		/ least(ABS($6),ABS(deviationB)) ) + 
            ( greatest(ABS($7),ABS(meanR))		/ least(ABS($7),ABS(meanR)) ) + 
            ( greatest(ABS($8),ABS(meanG))		/ least(ABS($8),ABS(meanG)) ) + 
            ( greatest(ABS($9),ABS(meanB))		/ least(ABS($9),ABS(meanB)) ) + 
            ( greatest(ABS($10),ABS(maxR))		/ least(ABS($10),ABS(maxR)) ) + 
            ( greatest(ABS($11),ABS(maxG))		/ least(ABS($11),ABS(maxG)) ) + 
            ( greatest(ABS($12),ABS(maxB))		/ least(ABS($12),ABS(maxB)) ) + 
            ( greatest(ABS($13),ABS(gapRatio1))		/ least(ABS($13),ABS(gapRatio1)) ) + 
            ( greatest(ABS($14),ABS(gapRatio2))		/ least(ABS($14),ABS(gapRatio2)) ) + 
            ( greatest(ABS($15),ABS(gapRatio3))		/ least(ABS($15),ABS(gapRatio3)) ) + 
            ( greatest(ABS($16),ABS(gapRatio4))		/ least(ABS($16),ABS(gapRatio4)) ) 
        )
        as difference
        from speciesAverage 
        where 
                whRatio BETWEEN ($1*$lfuzz) and ($1*$ufuzz) 
                and surfaceRatio BETWEEN ($2*$lfuzz) and ($2*$ufuzz) 
                and perimeterRatio BETWEEN ($3*$lfuzz) and ($3*$ufuzz) 
                and deviationR BETWEEN ($4*$lfuzz) and ($4*$ufuzz) 
                and deviationG BETWEEN ($5*$lfuzz) and ($5*$ufuzz) 
                and deviationB BETWEEN ($6*$lfuzz) and ($6*$ufuzz) 
                and meanR BETWEEN ($7*$lfuzz) and ($7*$ufuzz) 
                and meanG BETWEEN ($8*$lfuzz) and ($8*$ufuzz) 
                and meanB BETWEEN ($9*$lfuzz) and ($9*$ufuzz) 
                and maxR BETWEEN ($10*$lfuzz) and ($10*$ufuzz) 
                and maxG BETWEEN ($11*$lfuzz) and ($11*$ufuzz) 
                and maxB BETWEEN ($12*$lfuzz) and ($12*$ufuzz) 
                and gapRatio1 BETWEEN ($13*$lfuzz) and ($13*$ufuzz) 
                and gapRatio2 BETWEEN ($14*$lfuzz) and ($14*$ufuzz) 
                and gapRatio3 BETWEEN ($15*$lfuzz) and ($15*$ufuzz) 
                and gapRatio4 BETWEEN ($16*$lfuzz) and ($16*$ufuzz)
	ORDER BY difference ASC;
" -ss
