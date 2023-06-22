function distance = calcTDTDist(electrode1,electrode2)
electrodes = [1 3 5 7 2 4 6 8;10 12 14 16 9 11 13 15]';
elecdistx = [0 250 500 750 1000 1250 1500 1750;0 250 500 750 1000 1250 1500 1750]';
elecdisty = [0 0 0 0 0 0 0 0;375 375 375 375 375 375 375 375]';
[elec1WhereX,elec1WhereY] = find(electrodes==electrode1);
[elec2WhereX,elec2WhereY] = find(electrodes==electrode2);
if elec1WhereY == elec2WhereY
    distance = abs(elecdistx(elec1WhereX)-elecdistx(elec2WhereX));
else
    x1 = elecdistx(elec1WhereX,elec1WhereY);
    x2 = elecdistx(elec2WhereX,elec2WhereY);
    y1 = elecdisty(elec1WhereX,elec1WhereY);
    y2 = elecdisty(elec2WhereX,elec2WhereY);
    distance = sqrt((x1-x2)^2+(y1-y2)^2);
end