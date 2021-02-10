function DecisionValuea=CheckScoresSVM(DecisionValuea,PreLabelsa)

if DecisionValuea(find(PreLabelsa==1))<0
    DecisionValuea=DecisionValuea*-1;
end
if sum(DecisionValuea(find(PreLabelsa==2)))>0
    DecisionValuea=DecisionValuea*-1;
end
if sum(DecisionValuea(find(PreLabelsa==-1)))>0
    DecisionValuea=DecisionValuea*-1;
end