rows = 8068;
respCell = cell(1,rows);
class = cell(1,rows);
offsetTime = 1;
delayed = cell(1,rows);
inhib = cell(1,rows);
Xenergy = zeros(1,rows);
XISI = zeros(1,rows);
XPulses = zeros(1,rows);
respCounter = 0;
psth = zeros(1,200);
for ck = 1:8068
    if INSDataTable{ck,24} == 1
    curResp = INSDataTable{ck,10};
    meanSpont = mean(curResp(1:39));
    zScores = getZScoreSingle(curResp,'spont',[1 39]);
    numPulses = INSDataTable{ck,3};
    XPulses(ck) = numPulses;
    PW = INSDataTable{ck,4};
    curXenergy = (INSDataTable{ck,7}*10^(-3)).*(PW*10^(-3));
    if curXenergy < 0
        curXenergy = 0;
    end
    Xenergy(ck) = curXenergy;
    ISI = INSDataTable{ck,5};
    XISI(ck) = ISI;
    curStim = (PW*numPulses)+((numPulses-1)*ISI);
    stimBins = round(curStim/5);
    respWin = stimBins+10;
    resp = curResp(40:40+respWin);
    respZ = zScores(40:40+respWin);
    if max(respZ) < 3
        class{ck} = 'NR';
    elseif curStim < 30
        class{ck} = 'NR';
    else
        curClass = getPSTHClassMKIII(curResp,stimBins,meanSpont);
        class{ck} = curClass;
    end
    else
       class{ck} = 'NR';
    end
    psth(ck,:) = curResp;
end
actClasses = cell(1);
actClasses{1} = 'NR';
for bc = 1:rows
    curClass = class{bc};
    classFlag = 0;
    for ii = 1:length(actClasses)
        if strcmp(actClasses{ii},curClass)
            classFlag = 1;
        end
    end
    if classFlag == 0
        actClasses{length(actClasses)+1} = curClass;
    end

end
classMod = zeros(1,rows);
classDefs = [99,0,1,2,3,4,5,6];
for jk = 1:rows
    for tk = 1:length(actClasses)
        if strcmp(actClasses{tk},class{jk})
            classMod(jk) = classDefs(tk);
        end
    end
end
INSClassTable = cell(1);
INSBarsTable = cell(1);
counter = 1;
classCounts = [0,0,0,0,0,0,0];
sepClass = zeros(1,1);
sepPSTH = zeros(1,200);
for pk = 1:rows
    if strcmp(class{pk},'NR') == 0
        %if XPulses(pk) > 1
        if classMod(pk) < 99
            %if XISI(pk) <= 25
            INSClassTable{counter,1} = XPulses(pk);
            INSClassTable{counter,2} = Xenergy(pk);
            INSClassTable{counter,3} = XISI(pk);
            INSClassTable{counter,4} = class{pk};
            sepClass(counter) = classMod(pk); 
            INSClassTable{counter,5} = classMod(pk);
            classCounts(classMod(pk)+1) = classCounts(classMod(pk)+1) + 1;
            sepPSTH(counter,:) = psth(pk,:);
            counter = counter + 1;
            %end
        end
        %end
    end
end
nomFactorS = length(INSClassTable);
nomFactor = classCounts./nomFactorS(1);
%         maxWhere = find(resp == max(resp));
%         if maxWhere > (stimBins+offsetTime)
%             class{ck} = 'offset';
%         else
%             stimWin = curResp(40:40+respWin);
%             totBins = length(stimWin);
%             psthMax = max(stimWin);
%             psthMaxWhere = find(stimWin == psthMax);
%             if psthMaxWhere > 2
%                 delayed{ck} = 1;
%             else
%                 delayed{ck} = 0;
%             end
%             onsetSusFlag = 0;
%             for ii = 1:totBins
%                 if ii < psthMaxWhere
%                     continue
%                 else
%                     curRe = stimWin(ii);
%                     onsusration = psthMax/curRe;
%                     if onsusration > 3
%                         if curRe > meanSpont
%                             %class{ck} = 'OnSus';
%                             onsetSusFlag = 1;
%                         else
%                             %class{ck} = 'Onset';
%                             onsetSusFlag = 0;
%                         end
%                     else
%                         class{ck} = 'Sus';
%                     end
%                     if ii > stimBins
%                         if curRe < (0.95*meanSpont)
%                             inhib{ck} = 1;
%                         else
%                             inhib{ck} = 0;
%                         end
%                     end
%                 end
%                 if onsetSusFlag == 1
%                     class{ck} = 'OnSus';
%                 else
%                     class{ck} = 'Onset';
%                 end
%             end
%         end
%     end          
% end
% totClass = cell(1,rows);
% for ck = 1:rows
%     curClass = class{1,ck};
%     curInhib = inhib{1,ck};
%     if curInhib == 1
%         totClass{ck} = strcat(curClass,'+ Inhib');
%     else
%         totClass{ck} = curClass;
%     end
%     INSDataTable{ck,26} = totClass{ck};
% end
%         %30ms stimulus