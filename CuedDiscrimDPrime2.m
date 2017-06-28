CodePath = 'C:\Users\Feinberg Lab- Matlab\Documents'; 
DataPath = 'D:\Brooke\Data'; 
cd(DataPath); 
        
MiceFiles = dir(DataPath); 
NumMiceFiles = length(MiceFiles);   
PathsToAnalyze = cell.empty; 



for i = 3:NumMiceFiles
    

    %Check if file has been accessed        
   
    cd(DataPath);
    MouseFolder = MiceFiles(i).name; 
    BHfile = findstr(MouseFolder, 'BH'); 
    
    if isempty(BHfile) == 0
        
    addpath(MouseFolder); 
    MouseFolderDataPath = strcat(DataPath, '\', MouseFolder); 
    cd(MouseFolderDataPath); 
    MouseFolderFiles = dir(MouseFolderDataPath); 
    NumDateFiles = length(MouseFolderFiles); 
    Dates = zeros((NumDateFiles-2), (NumMiceFiles-2)); 
    
    for x = 3:NumDateFiles 
        
        DateFile =  MouseFolderFiles(x).name; 
        DateFilePath = strcat(MouseFolderDataPath, '\', DateFile); 
        cd(DateFilePath); 
  
        PathsToAccess = cell.empty; 
               
       AccessStamp = dir('*.txt');
       NumStamps = length(AccessStamp); 
       
       if isempty(AccessStamp) == 0 
       
       for z = 1:NumStamps
           
           StampName = AccessStamp(z).name; 
           PrimeStamp = findstr(StampName, 'Prime'); 
       end 
       
       end 
           
        if isempty(AccessStamp) == 1| isempty(PrimeStamp) == 1
                   
             PathToAccess = [DateFilePath] ; 
             PathsToAccess = cellstr(PathToAccess);                           

        end 
        
     if isempty(PathsToAnalyze) == 1
        
         PathsToAnalyze = PathsToAccess; 
        
     else 
        
        PathsToAnalyze = [PathsToAnalyze; PathsToAccess]; 
        
     end 
    
     PathsToAnalyze; 

    end
   
end 
end 

 %check if file has been accessed yet 
for i = 3:NumMiceFiles
    
    cd(DataPath);
    MouseFolder = MiceFiles(i).name;
    BHfile = findstr(MouseFolder, 'BH'); 
    
    if isempty(BHfile) == 0
    
    MouseFolderDataPath = strcat(DataPath, '\', MouseFolder); 
    cd(MouseFolderDataPath); 
    MouseFolderFiles = dir(MouseFolderDataPath);
    NumDateFiles = length(MouseFolderFiles); 
    
    for i = 1:NumDateFiles
    
        DateFile = MouseFolderFiles(i).name; 
        DateFilePath = strcat(MouseFolderDataPath, '\', DateFile);
        cd(DateFilePath);

        PathsToAccess = cell.empty; 
               
       AccessStamp = dir('*.txt'); 
       
       if isempty(AccessStamp) == 0 
           
           StampName = AccessStamp.name; 
           AnalyzeStamp = findstr(StampName, 'Access'); 
       end        
     
     if DateFilePath(end) ~= '.'
           
     if isempty(AccessStamp) == 1 | isempty(AnalyzeStamp) == 1
                   
             PathToAccess = [DateFilePath] ; 
             PathsToAccess = cellstr(PathToAccess);                           
     end 
        
     if isempty(PathsToAnalyze) == 1
        
         PathsToAnalyze = PathsToAccess;        
     else 
        
        PathsToAnalyze = [PathsToAnalyze; PathsToAccess]; 
     end 
    
       end 
    
    end
end 
end 

 PathsToAnalyze; 
 NumPathsToAnalyze = length(PathsToAnalyze); 
 
 for z = 1: NumPathsToAnalyze
     

AnalysisPath = char(PathsToAnalyze(z)) 
cd(AnalysisPath); 

 
NumDataFiles = length(dir('*.dat'));

TotalFrames = zeros(NumDataFiles, 1); 

 AllStims = single.empty(500000, 0); 
 AllRewards = single.empty(500000, 0); 
 AllLicks = single.empty(500000, 0); 
  AllTime = single.empty(500000, 0); 
 AllRZ = single.empty(500000, 0);
  AllDist = single.empty(500000, 0); 
 AllStimSizes = single.empty(500000, 0);
  AllStimSide = single.empty(500000, 0);
AllCueSide = single.empty(500000, 0);
 AllStimMotion = single.empty(500000, 0);
 
   
   AllFiles = dir('*.dat'); 
  StartFile = AllFiles(1).name; 
  FileIt = str2num(StartFile(1)); 
  
  if FileIt == 0 
      
      StartIt = 1; 
      
  else if FileIt == 1
      
      StartIt = 2; 
      
      end 
  end 

for x = StartIt:NumDataFiles
    
    FileIt = num2str(x-1);
    
    Dat = 'Licks&Position.dat'; 
    Encoder = strcat(AnalysisPath, '\', FileIt, Dat);  

movfile = fopen(Encoder);
movpath = dir(Encoder); 
movbytsize = movpath.bytes;

movnu = movbytsize/(11*4+8);

if rem(movnu, 1) == 0 

TotalFrames(x, 1) = movnu; 
%red stamp, PCO it, eye it, elapsed time, eye track, stim & position, movie

fseek(movfile, 11*4 ,'bof');
Timer = zeros(movnu, 1);

for y = 1:movnu

    Time = fread(movfile, 1 , 'double', 0, 'ieee-be'); %
    Timer(y, 1)= Time; 
    fseek(movfile,11*4,'cof');
   
end

Timer = round(Timer, 2);

%read stim info and mouse position:
%Total Dist traveled,  Rand Dist Generated  
%Stim, Lick?, Reward?, Dist at Lick 
%Variant Stims:
%2/1 (Small or Large), 2/1 (Left or Right Stim), 2/1/0 (Left, Right, or No Cue),
%1/2 (Immobile or Mobile Stim -- mouses reference point) 

frewind(movfile);
fseek(movfile, 0 ,'bof');
StimPos = zeros(movnu, 12);  
Zeros = zeros(1, 12); 

for y = 1:movnu
    
    Stiminfo = fread(movfile, 11 ,'single',0,'ieee-be');  
    StimInfo = Stiminfo';
    StimPos(y, 1:11)= StimInfo;
     
    StimPos(y, 12) = y; 
    
    fseek(movfile, 8,'cof'); %places cof at end of next cam data so continue with next wheel frame
    
end 

StimnLick = zeros(movnu, 5); 

StimnLick(:, 1) = StimPos(:, 3); %stim
StimnLick(:, 2) = StimPos(:, 4);%lick
StimnLick(:, 3) = StimPos(:, 5); %reward
StimnLick(:, 4) = Timer(:, 1); 
StimnLick(:, 5) = StimPos(:, 6);
StimnLick(:, 6) = StimPos(:, 1);

Stims = StimnLick(:, 1); 
Licks = StimnLick(:, 2); 
Rewards = StimnLick(:, 3);
Timer = StimnLick(:, 4);
RZDist = StimnLick(:, 5);
Dist= StimnLick(:, 6);
StimSize = StimPos(:, 7); 
StimSide = StimPos(:, 8);
CueSide = StimPos(:, 9);
StimMotion = StimPos(:, 10);


if x == StartIt
    
    AllStims(1:movnu) = Stims;
    AllLicks(1:movnu) = Licks;
    AllReward(1:movnu) = Rewards;
    AllTime(1:movnu) = Timer;
    AllRZ(1:movnu) = RZDist;
    AllDist(1:movnu) = Dist;
    AllStimSizes(1:movnu) = StimSize;
    AllStimSide(1:movnu) = StimSide;
    AllCueSide(1:movnu) = CueSide;
    AllStimMotion(1:movnu) = StimMotion;
    
else if x > StartIt
    
    AllStimLengths = length(AllStims);  
    StartFill = AllStimLengths+1; 
    AllStims(StartFill: (StartFill+movnu) - 1) = Stims; 
    
    AllRewards(StartFill: (StartFill+movnu) - 1) = Rewards;   
    AllLicks(StartFill: (StartFill+movnu) - 1) = Licks;
    AllTime(StartFill: (StartFill+movnu) - 1) = Timer;
    AllRZ(StartFill: (StartFill+movnu) - 1) = RZDist;
    AllDist(StartFill: (StartFill+movnu) - 1) = Dist;
    AllStimSizes(StartFill: (StartFill+movnu) - 1) = StimSize;
    AllStimSide(StartFill: (StartFill+movnu) - 1) = StimSide;
    AllCueSide(StartFill: (StartFill+movnu) - 1) = CueSide;
    AllStimMotion(StartFill: (StartFill+movnu) - 1) = StimMotion;
     
    end
end
%    AllStims; 
%     length(Stims) 
%     length(AllStims)
fclose('all'); 
end

end 

StimLength = AllStimSizes'; 
StimSide = AllStimSide'; 
CueSide = AllCueSide'; 
StimMotion = AllStimMotion'; 
RZDist = round(AllRZ)'; 
Stims = AllStims';
Licks = AllLicks';
Rewards = AllRewards';
Timer = AllTime';
TotalDist = AllDist';
[r c] = size(TotalDist); 


TotalLength = length(Stims); 
Velocity = zeros(TotalLength, 1);

for i = 2:(TotalLength-1) 
    
%instant running speed 

DeltaDist = TotalDist((i+1), 1) - TotalDist((i-1), 1); 
DeltaTime = Timer((i+1), 1)- Timer((i-1), 1); 
Velocity(i, 1) = DeltaDist / DeltaTime; 

end

%find deriv/change in value of licks 

derivLicks = diff(Licks); 
NumDiffLicks = length(derivLicks); 

DerivLicks  = abs(derivLicks); 
DerivLicks = [0; DerivLicks]; 
%Licks = DerivLicks; 


%finds occurences of  vertical stimuli
VertStimNum = find((Stims(:, 1) == 2));   
NumStim = length(VertStimNum); 
AllVertStim = zeros(NumStim, 1); 

for i = 1:NumStim 
    
    if i == 1 
        AllVertStim(i, 1) = VertStimNum(i);  

    else
        if VertStimNum(i)-VertStimNum(i-1) < 10
        AllVertStim(i, 1) = 0; 
    else 
        AllVertStim(i, 1) = VertStimNum(i);
    end 
    end 
end 

AllVertStim = nonzeros(AllVertStim);   
NumVertStim = length(AllVertStim); 

%separate according to left or right cue side 

RightCuedVert = zeros(NumVertStim, 1); 
LeftCuedVert = zeros(NumVertStim, 1);
NotCuedVert = zeros(NumVertStim, 1);

for i = 1:NumVertStim
    
    StimIt = AllVertStim(i) ; 
    
    StimCueSide = CueSide(StimIt:StimIt+5); 
    StimCueSide = mode(StimCueSide); 
    
    if StimCueSide == 2 %left side 
        
        LeftCuedVert(i, 1) = StimIt; 
    end 
        
     if StimCueSide == 1 %right side 
            
        RightCuedVert(i, 1) = StimIt;
     end
    
     if StimCueSide == 3 %left side 
        
        NotCuedVert(i, 1) = StimIt; 
    end 
end 

RightCuedVert = nonzeros(RightCuedVert); 
LeftCuedVert = nonzeros(LeftCuedVert);
NotCuedVert = nonzeros(NotCuedVert);

NumRCuedVert = length(RightCuedVert)
NumLCuedVert = length(LeftCuedVert)
NumNotCuedVert = length(NotCuedVert)


    

%finds occurences of  diagonal stimuli
DiagStimNum = find((Stims(:, 1) == 1));   
NumDiagStim = length(DiagStimNum); 
DiagStimIts = zeros(NumDiagStim, 1); 

for i = 1:NumDiagStim 
    
    if i == 1 
        DiagStimIts(i, 1) = DiagStimNum(i);  

    else
        if DiagStimNum(i)-DiagStimNum(i-1) < 10
        DiagStimIts(i, 1) = 0; 
    else 
        DiagStimIts(i, 1) = DiagStimNum(i);
    end 
    end 
end 

AllDiagStim = nonzeros(DiagStimIts);
NumDiagStim = length(AllDiagStim) 



RightCuedDiag = zeros(NumDiagStim, 1); 
LeftCuedDiag = zeros(NumDiagStim, 1);
NotCuedDiag = zeros(NumDiagStim, 1);

for i = 1: NumDiagStim
    
    DiagStim = AllDiagStim(i); 
    StimCueSide = CueSide(DiagStim:DiagStim +5); 
    StimCueSide = mode(StimCueSide);      
    
    if StimCueSide == 2
        
        LeftCuedDiag(i, 1) = DiagStim;
        
    end
        
    if StimCueSide == 1 
        
       RightCuedDiag(i, 1) = DiagStim; 
    end
    
    if StimCueSide == 3 
        
       NotCuedDiag(i, 1) = DiagStim; 
    end
end 

LeftCuedDiag = nonzeros(LeftCuedDiag); 
RightCuedDiag = nonzeros(RightCuedDiag); 
NotCuedDiag = nonzeros(NotCuedDiag);

NumLCuedDiag = length(LeftCuedDiag) 
NumRCuedDiag = length(RightCuedDiag)
NumNotCuedDiag = length(NotCuedDiag)


%lick analysis for right cued stim 

RightCuedHits = zeros(NumRCuedVert, 1);
RightHitLatencies  = zeros(NumRCuedVert, 1);

for i = 1: NumRCuedVert
    
    StimIt = RightCuedVert(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.8; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if isempty(Licked) == 0
        
        RightCuedHits(i, 1) = StimIt; 
        
        FirstLick = Licked(1); 
        LickIt = (StimIt + FirstLick) - 1; 
        LickTime = Timer(LickIt); 

        LickLatency = LickTime - StimTime; 
        RightHitLatencies(i, 1) = LickLatency; 
        
    end    
    
end 

RightCuedHits = nonzeros(RightCuedHits); 
NumRightHits = length(RightCuedHits) 


RightHitLatencies = nonzeros(RightHitLatencies); 
AvgRHitTime = mean(RightHitLatencies)*1000 

RightFALatencies  = zeros(NumRCuedDiag, 1);
RightCuedFAs = zeros(NumRCuedDiag, 1); 

for i = 1: NumRCuedDiag
    
    StimIt = RightCuedDiag(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.8; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if length(Licked) > 0 %isempty(Licked) == 0
        
        RightCuedFAs(i, 1) = StimIt; 
        FirstLick = Licked(1); 
        LickIt = (StimIt + FirstLick) - 1; 
        LickTime = Timer(LickIt); 

        LickLatency = LickTime - StimTime; 
        RightFALatencies(i, 1) = LickLatency; 
        
    end    
    
end 

RightCuedFAs = nonzeros(RightCuedFAs); 
NumRightFAs = length(RightCuedFAs) 

RightFALatencies = nonzeros(RightFALatencies); 
AvgRightFATime = mean(RightFALatencies)*1000; 


%calc behavioral d-prime for right cued 
 
RightFAFrac = NumRightFAs/NumRCuedDiag;   
RightHitFrac = NumRightHits/NumRCuedVert;   


if RightFAFrac == 0
    RightFAFrac = 0.01
end
if RightFAFrac == 1
    RightFAFrac = 0.99
end



if RightHitFrac == 0
    RightHitFrac = 0.01
end
if RightHitFrac == 1
    RightHitFrac = 0.99
end


RightHitNormInv = norminv(RightHitFrac,0,1)
RightFANormInv = norminv(RightFAFrac,0,1)

RightDPrime = RightHitNormInv - RightFANormInv



%lick analysis for left cued 

LeftCuedHits = zeros(NumLCuedVert, 1); 
LeftHitLatencies = zeros(NumLCuedVert, 1); 

for i = 1: NumLCuedVert
    
    StimIt = LeftCuedVert(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.8; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if isempty(Licked) == 0
        
        LeftCuedHits(i, 1) = StimIt; 
        
        FirstLick = Licked(1); 
        LickIt = (StimIt + FirstLick) - 1; 
        LickTime = Timer(LickIt); 

        LickLatency = LickTime - StimTime; 
        LeftHitLatencies(i, 1) = LickLatency; 
        
    end   
   
end 

LeftCuedHits = nonzeros(LeftCuedHits); 
NumLeftHits = length(LeftCuedHits); 


LeftHitLatencies = nonzeros(LeftHitLatencies); 
AvgLHitTime = mean(LeftHitLatencies)*1000

LeftFALatencies = zeros(NumLCuedDiag, 1); 
LeftCuedFAs = zeros(NumLCuedDiag, 1); 

for i = 1: NumLCuedDiag
    
    StimIt = LeftCuedDiag(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.8; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if length(Licked) > 0 %isempty(Licked) == 0
        
        LeftCuedFAs(i, 1) = StimIt;      
        
        FirstLick = Licked(1); 
        LickIt = (StimIt + FirstLick) - 1; 
        LickTime = Timer(LickIt); 

        LickLatency = LickTime - StimTime; 
        LeftFALatencies(i, 1) = LickLatency; 
        
    end    
    
end 

LeftCuedFAs = nonzeros(LeftCuedFAs); 
NumLeftFAs = length(LeftCuedFAs); 


LeftFALatencies = nonzeros(LeftFALatencies); 
AvgLeftFATime = mean(LeftFALatencies)*1000; 


%calc behavioral d-prime for variants

LeftHitFrac = NumLeftHits/NumLCuedVert;
LeftFAFrac = NumLeftFAs/NumLCuedDiag;

if LeftFAFrac == 0
    LeftFAFrac = 0.01
end
if LeftFAFrac == 1
    LeftFAFrac = 0.99
end


if LeftHitFrac == 0
    LeftHitFrac = 0.01
end
if LeftHitFrac == 1
    LeftHitFrac = 0.99
end

LeftHitNormInv = norminv(LeftHitFrac,0,1)
LeftFANormInv = norminv(LeftFAFrac,0,1)


LeftDPrime = LeftHitNormInv - LeftFANormInv





%lick analysis for left cued 

NotCuedHits = zeros(NumNotCuedVert, 1); 
NotCuedHitLatencies = zeros(NumNotCuedVert, 1); 

for i = 1: NumNotCuedVert
    
    StimIt = NotCuedVert(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.5; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if isempty(Licked) == 0
        
        NotCuedHits(i, 1) = StimIt; 
        
        FirstLick = Licked(1); 
        LickIt = (StimIt + FirstLick) - 1; 
        LickTime = Timer(LickIt); 

        LickLatency = LickTime - StimTime; 
        NotCuedHitLatencies(i, 1) = LickLatency; 
        
    end   
   
end 

NotCuedHits = nonzeros(NotCuedHits); 
NumNotHits = length(NotCuedHits); 


NotCuedHitLatencies = nonzeros(NotCuedHitLatencies); 
AvgLHitTime = mean(NotCuedHitLatencies)*1000

NotCuedFALatencies = zeros(NumNotCuedDiag, 1); 
NotCuedFAs = zeros(NumNotCuedDiag, 1); 

for i = 1: NumNotCuedDiag
    
    StimIt = NotCuedDiag(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.5; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if length(Licked) > 0 %isempty(Licked) == 0
        
        NotCuedFAs(i, 1) = StimIt;      
        
        FirstLick = Licked(1); 
        LickIt = (StimIt + FirstLick) - 1; 
        LickTime = Timer(LickIt); 

        LickLatency = LickTime - StimTime; 
        NotCuedFALatencies(i, 1) = LickLatency; 
        
    end    
    
end 

NotCuedFAs = nonzeros(NotCuedFAs); 
NumNotFAs = length(NotCuedFAs); 


NotCuedFALatencies = nonzeros(NotCuedFALatencies); 
AvgNotFATime = mean(NotCuedFALatencies)*1000; 


%calc behavioral d-prime for variants

NotHitFrac = NumNotHits/NumNotCuedVert;
NotFAFrac = NumNotFAs/NumNotCuedDiag;

if NotFAFrac == 0
    NotFAFrac = 0.01
end
if NotFAFrac == 1
    NotFAFrac = 0.99
end


if NotHitFrac == 0
    NotHitFrac = 0.01
end
if NotHitFrac == 1
    NotHitFrac = 0.99
end

NotHitNormInv = norminv(NotHitFrac,0,1)
NotFANormInv = norminv(NotFAFrac,0,1)


NotDPrime = NotHitNormInv - NotFANormInv


TotalTrials = NumVertStim + NumDiagStim;

%save data for mouse on consecutive days 

FindStart = findstr(AnalysisPath, 'BH'); 
Date = AnalysisPath(FindStart+6:end);  
MouseName = AnalysisPath(FindStart:FindStart+4);
SaveString = AnalysisPath(FindStart:end); 
MousePath = strcat(CodePath, '\', 'Analyzed', '\', MouseName);  

% LeftFAStr = num2str(LeftFAFrac); 
% LeftHitStr = num2str(DefaultHitFrac); 
% 
% VariantFAStr = num2str(VariantFAFrac); 
% VariantHitStr = num2str(VariantHitFrac); 
% 
% TotalFAStr = num2str(TotalFAFrac); 
% TotalHitStr = num2str(TotalHitFrac); 

cd(MousePath); 
fileID = fopen('AllDPrime.txt','a');
formatSpec = '%s\n';
fprintf(fileID, formatSpec , Date);
dlmwrite('AllDPrime.txt',TotalTrials, '-append');
dlmwrite('AllDPrime.txt',LeftHitFrac, '-append');
dlmwrite('AllDPrime.txt',LeftFAFrac,'-append');
dlmwrite('AllDPrime.txt',LeftDPrime,'-append');
dlmwrite('AllDPrime.txt',RightHitFrac, '-append');
dlmwrite('AllDPrime.txt',RightFAFrac,'-append');
dlmwrite('AllDPrime.txt',RightDPrime,'-append');
dlmwrite('AllDPrime.txt',NotHitFrac, '-append');
dlmwrite('AllDPrime.txt',NotFAFrac,'-append');
dlmwrite('AllDPrime.txt',NotDPrime,'-append');
dlmwrite('AllDPrime.txt',AvgLHitTime,'-append');
dlmwrite('AllDPrime.txt',AvgRHitTime,'-append');
dlmwrite('AllDPrime.txt',AvgLeftFATime,'-append');
dlmwrite('AllDPrime.txt',AvgRightFATime,'-append');
fclose(fileID);

cd(AnalysisPath); 
fileID = fopen('AllDPrime.txt','w');
formatSpec = '%s\n';
fprintf(fileID, formatSpec , Date);
dlmwrite('AllDPrime.txt',TotalTrials, '-append');
dlmwrite('AllDPrime.txt',LeftHitFrac, '-append');
dlmwrite('AllDPrime.txt',LeftFAFrac,'-append');
dlmwrite('AllDPrime.txt',LeftDPrime,'-append');
dlmwrite('AllDPrime.txt',RightHitFrac, '-append');
dlmwrite('AllDPrime.txt',RightFAFrac,'-append');
dlmwrite('AllDPrime.txt',RightDPrime,'-append');
fclose(fileID);

 end 
 
 
 %open cummulative data files for analysis 

cd(CodePath);
AnalyzedPath = strcat(CodePath, '\', 'Analyzed'); 
MiceAnalysisFolders = dir(AnalyzedPath); 
NumMiceAnalyFiles = length(MiceAnalysisFolders);

% OverlayedDPrimes = figure('name', 'All DPrimes');
TrueNegFracs = zeros(10, (NumMiceAnalyFiles-3));
b = 0; 

for i = 3:NumMiceAnalyFiles
    
    MouseAnalyFolder = MiceAnalysisFolders(i).name;
    BHFile = findstr(MouseAnalyFolder, 'BH'); 
    
    if isempty(BHFile) == 0
        
        b = b+1; 
        if b == 1           
            FoldersToAnalyze = MouseAnalyFolder;             
        else  
            FoldersToAnalyze = [FoldersToAnalyze; MouseAnalyFolder]; 
        end
        
    end 
    
end 

[NumAnalyFolders, width] = size(FoldersToAnalyze);


AllRightFAFracs = zeros(16, (NumAnalyFolders));
AllLeftFAFracs = zeros(16, (NumAnalyFolders));
AllRightHitFracs = zeros(16, (NumAnalyFolders));
AllLeftHitFracs = zeros(16, (NumAnalyFolders));
AllNotHitFracs = zeros(16, (NumAnalyFolders));
AllNotFAFracs = zeros(16, (NumAnalyFolders));

AllRightDPrimes = zeros(16, (NumAnalyFolders)); 
AllLeftDPrimes = zeros(16, (NumAnalyFolders)); 
AllNotDPrimes = zeros(16, (NumAnalyFolders)); 

AllTrials = zeros(16, (NumAnalyFolders)); 
AllLHitAvgs = zeros(16, (NumAnalyFolders));
AllRHitAvgs = zeros(16, (NumAnalyFolders));
AllRFAAvgs = zeros(16, (NumAnalyFolders));
AllLFAAvgs = zeros(16, (NumAnalyFolders));


Dates = zeros(16, (NumAnalyFolders)); 
 
MouseNames = cell(NumAnalyFolders, 1);

for i = 1:NumAnalyFolders

    MouseAnalyFolder = FoldersToAnalyze(i, :); 
    MouseFolderAnalyPath = strcat(AnalyzedPath, '\', MouseAnalyFolder); 
    cd(MouseFolderAnalyPath); 
    DPrimeFileCreated = dir('*.txt'); 
    FoldersPresent = dir(MouseFolderAnalyPath);  
    NumFolders = length(FoldersPresent);  
    NumDateFolders = zeros(NumFolders, 1); 
     
     if i == 1
        
        MouseNames  = cellstr(MouseAnalyFolder); 
        
    else 
        
        MouseName = cellstr(MouseAnalyFolder); 
        MouseNames = [MouseNames MouseName]; 
        
    end
   
    for x = 3:NumFolders
        
        FolderName =  FoldersPresent(x).name;  
        AMFolders = length(findstr(FolderName, 'AM'));  
        PMFolders = length(findstr(FolderName, 'PM'));
        
        NumDateFolders(x, 1) = AMFolders + PMFolders; 
        
    end 
    
    NumDateFolders = sum(NumDateFolders); 
    
    if isempty(DPrimeFileCreated) == 0
        
        fileID = fopen('AllDPrime.txt','r');
        FirstChars = zeros(NumDateFolders*16, 1);
        DPrimeDates = cell(NumDateFolders, 1); 
        DPrimeData = zeros(NumDateFolders*16, 1);
        a = 0; 
        
        for x = 1:(NumDateFolders*15)
            
        x;  
        LineRead = fgetl(fileID); 
        LineLength = length(LineRead);
        
        if LineLength > 11
            
            a = a + 1; 
            FirstChars(x, 1) = str2num(LineRead(1)); 
            LineRead = cellstr(LineRead); 
            DPrimeDates(a, 1) = LineRead; 
        
        else
            
            LineRead = char(LineRead(1, :)); 
            NumRead = str2num(LineRead);
            if NumRead == 0 
                
                NumRead = 0.01; 
                
            end
            
            DPrimeData(x, 1) = NumRead;
            
        end 
            
        end 
        
        DPrimeDates ; 
        
        DPrimeData = nonzeros(DPrimeData); 
        DPrimeData = reshape(DPrimeData, 14, []);                            
        
    end
    
    NumPrimeDates = length(DPrimeDates);
   
    
%sort files in order of date 
        
    for x = 1:NumPrimeDates 
        
        x; 
     PrimeDate = DPrimeDates(x, :); 
     PrimeDate = char(PrimeDate); 
     PrimeDate = strcat(PrimeDate); 
    FirstComma = findstr(PrimeDate, ','); 
    StartDateString = FirstComma(1) + 2; 
    
    FindEnd = findstr(PrimeDate, 'PM');
    
    if isempty(FindEnd) == 1
         FindEnd = findstr(PrimeDate, 'AM');
    end 
    
    EndDateString = FindEnd-5; 
    DateString = PrimeDate(StartDateString:EndDateString); 
    
    Minutes= DateString(end-1:end); 
    Hour = DateString(end-3:end-2); 
    
    if Hour(1) == ' ' 
        
        Hour(1) = '0'; 
        DayYr = DateString(end-11:end-4);
        
    else 
        DayYr = DateString(end-12:end-5);
        
    end 
    
    Time = strcat(Hour, ':', Minutes); 
    Month = DateString(1:3); 
    DayYr = strcat(DayYr(1:3), DayYr(5:end)); 
    Date = strcat(Month, '.', DayYr); 
    Date = [Date, ' ', Time];
    format = 'mmm.dd,yyyy HH:MM'; 
    DateNum = datenum(Date);
    DateNumString = num2str(DateNum); 
    
    Dates(x, i) = DateNum; 
    
     
    end
    
    
    FirstChars = nonzeros(FirstChars);
    NumFirstChars = length(FirstChars);     
    
    Trials = DPrimeData(1, :);
    Trials = Trials';
    
    LeftHitFracs = DPrimeData(2, :); 
    LeftHitFracs = LeftHitFracs'; 
    
    LeftFAFracs = DPrimeData(3, :); 
    LeftFAFracs = LeftFAFracs' ;
    
    RightHitFracs = DPrimeData(5, :); 
    RightHitFracs = RightHitFracs'; 
    
    RightFAFracs = DPrimeData(6, :); 
    RightFAFracs = RightFAFracs' ;
        
    LeftDPrimes = DPrimeData(4, :); 
    LeftDPrimes =  LeftDPrimes';
    
    RightDPrimes = DPrimeData(7, :); 
    RightDPrimes =  RightDPrimes';
    
    NotHitFracs = DPrimeData(8, :); 
    NotHitFracs = NotHitFracs'; 
    
    NotFAFracs = DPrimeData(9, :); 
    NotFAFracs = NotFAFracs' ;
        
    NotDPrimes = DPrimeData(10, :); 
    NotDPrimes =  NotDPrimes';
    
    LeftHitLickTime = DPrimeData(11, :);
    LeftHitLickTime = LeftHitLickTime';    
     
    RightHitLickTime = DPrimeData(12, :);
    RightHitLickTime = RightHitLickTime';  
    
    LeftFALickTime = DPrimeData(13, :);
    LeftFALickTime = LeftFALickTime';    
     
    RightFALickTime = DPrimeData(14, :);
    RightFALickTime = RightFALickTime'; 
    
    

   
    
%     for x = 2:NumFirstChars 
%         
%         
%         SameDay = FirstChars(x,1) - FirstChars((x-1),1); 
%        
%        if SameDay == 0 
%            
%            AvgFAFrac = mean([TotalFAFracs(x-1) TotalFAFracs(x)]); 
%            AvgHitFrac = mean([HitFracs(x-1) HitFracs(x)]); 
%            
%            AvgFANorm = norminv(AvgFAFrac); 
%            AvgHitNorm = norminv(AvgHitFrac);
%            
%            AvgDPrime = AvgHitNorm-AvgFANorm; 
%            
%            TotalDPrimes(x) = AvgDPrime; 
%            TotalDPrimes(x-1) = 0; 
%            
%            AvgTrials = mean([Trials(x-1) Trials(x)]);  
%            
%            Trials(x) = AvgTrials; 
%            Trials(x-1) = 0; 
%            
%            HitFracs(x) = AvgHitFrac; 
%            HitFracs(x-1) = 0; 
%            
%            TotalFAFracs(x) = AvgFAFrac; 
%            TotalFAFracs(x-1) = 0; 
%            
%            Dates((x-1), i) = 0; 
%            
%        end 
%     end
    
    
    
    Trials = nonzeros(Trials); 
    NumTrials = length(Trials); 
    AllTrials(1:NumTrials, i) = Trials; 
    
    LeftDPrimes = nonzeros(LeftDPrimes); 
    NumDefaultPrimes = length(LeftDPrimes);
    AllLeftDPrimes(1:NumDefaultPrimes, i) = LeftDPrimes; 
    
    RightDPrimes = nonzeros(RightDPrimes); 
    NumVariantPrimes = length(RightDPrimes);    
    AllRightDPrimes(1:NumDefaultPrimes, i) = RightDPrimes; 
    
    LeftHitLickTime = nonzeros(LeftHitLickTime); 
    NumLeftTimes = length(LeftHitLickTime); 
    AllLHitAvgs(1:NumLeftTimes, i) = LeftHitLickTime; 
    
    RightHitLickTime = nonzeros(RightHitLickTime); 
    NumRightTimes = length(RightHitLickTime); 
    AllRHitAvgs(1:NumRightTimes, i) = RightHitLickTime; 
    
     
    LeftFALickTime = nonzeros(LeftFALickTime); 
    NumLeftTimes = length(LeftFALickTime); 
    AllLFAAvgs(1:NumLeftTimes, i) = LeftFALickTime; 
    
    RightFALickTime = nonzeros(RightFALickTime); 
    NumRightTimes = length(RightFALickTime); 
    AllRFAAvgs(1:NumRightTimes, i) = RightFALickTime; 
    
    LeftHitFracs = nonzeros(LeftHitFracs); 
    NumLHits = length(LeftHitFracs); 
    AllLeftHitFracs(1:NumLHits, i) = LeftHitFracs;  
    
    RightHitFracs = nonzeros(RightHitFracs); 
    NumRHits = length(RightHitFracs); 
    AllRightHitFracs(1:NumRHits, i) = RightHitFracs;
    
    LeftFAFracs = nonzeros(LeftFAFracs); 
     NumLFAs = length(LeftFAFracs); 
    AllLeftFAFracs(1:NumLHits, i) = LeftFAFracs;
    
    RightFAFracs = nonzeros(RightFAFracs); 
     NumRFAs = length(RightFAFracs); 
    AllRightFAFracs(1:NumRHits, i) = RightFAFracs;
    
     NotFAFracs = nonzeros(NotFAFracs); 
     NumNotFAs = length(NotFAFracs); 
    AllNotFAFracs(1:NumNotFAs, i) = NotFAFracs;
    
    NotFAHits = nonzeros(NotHitFracs); 
     NumNotHits = length(NotHitFracs); 
    AllNotHitFracs(1:NumNotHits, i) = NotHitFracs;
    
    RightDPrimes = nonzeros(RightDPrimes); 
    NumVariantPrimes = length(RightDPrimes);    
    AllRightDPrimes(1:NumDefaultPrimes, i) = RightDPrimes;
     

    end 


% cd(AnalyzedPath); 
% FigureSaveName = 'Behavioral_DPrimes_as_of_7/20.png'; 
% FigureSave = strcat(pwd, '\', FigureSaveName); 
% saveas(gcf, FigureSaveName); 
% %close(VertTrialsOne); 


NumMiceFolders = 0; 

for i = 1:NumMiceAnalyFiles
    
    FolderName = MiceAnalysisFolders(i).name;
    BHFolder = findstr(FolderName, 'BH'); 
    
    if isempty(BHFolder) == 0
        
       NumMiceFolders = NumMiceFolders +1; 
       
    end 
    
end 

NumMiceFolders; 

AllIndivDPrimes = figure('name', 'All Indiv DPrimes Variants'); 

for i = 1:(NumMiceFolders)

    subplot(2, 2, i); 
    
    IndivRightPrimes = AllRightDPrimes(:, i); 
    IndivRightPrimes = nonzeros(IndivRightPrimes); 
     
    IndivLeftPrimes = AllLeftDPrimes(:, i); 
    IndivLeftPrimes = nonzeros(IndivLeftPrimes); 
         
    
    MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
    plot(RelativeDays,  IndivRightPrimes, '-o', RelativeDays,  IndivLeftPrimes, '-o');
    title(MouseName); 
    hold on;  
 
   if i == 2
       
      legend('Right Cued DPrime', 'Left Cued DPrime', 'Location','northoutside', 'Orientation','horizontal'); 
       
   end 
    
end

LickLatencies = figure('name', 'Average Hit Lick Latencies')

for i = 1:(NumMiceFolders)
    
   subplot(2, 2, i); 
   
    RightLickLatency = AllRHitAvgs(:, i); 
    RightLickLatency = nonzeros(RightLickLatency); 
    
    LeftLickLatency = AllLHitAvgs(:, i); 
    LeftLickLatency = nonzeros(LeftLickLatency);
    
     MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
    if NumDays == 1
        
      plot(RelativeDays,  RightLickLatency, '-o', RelativeDays,  LeftLickLatency, '-x');
     title(MouseName); 
        hold on;    
        
    else 
        
    plot(RelativeDays,  RightLickLatency, '-o', RelativeDays,  LeftLickLatency, '-o');
    title(MouseName); 
    hold on;  
    
    end
 
   if i == 2
       
      legend('Right Cued Hit Lick Latency', 'Left Cued Hit Lick Latency', 'Location','northoutside', 'Orientation','horizontal'); 
   end   
    
end 


LickLatencies = figure('name', 'Average False Alarm Lick Latencies')

for i = 1:(NumMiceFolders)
    
   subplot(2, 2, i); 
   
    RightLickLatency = AllRFAAvgs(:, i); 
    RightLickLatency = nonzeros(RightLickLatency); 
    
    LeftLickLatency = AllLFAAvgs(:, i); 
    LeftLickLatency = nonzeros(LeftLickLatency);
    
     MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
    if NumDays == 1
      
            plot(RelativeDays,  RightLickLatency, '-o', RelativeDays,  LeftLickLatency, '-x');
             title(MouseName); 
            hold on;
        
    else 
        
    plot(RelativeDays,  RightLickLatency, '-o', RelativeDays,  LeftLickLatency, '-o');
    title(MouseName); 
    hold on;
    
    end 
 
   if i == 2
       
      legend('Right Cued FA Lick Latency', 'Left Cued FA Lick Latency', 'Location','northoutside', 'Orientation','horizontal'); 
   end   
    
end 


HitsAndFAs = figure('name', 'Hits and False Alarms Rates')

for i = 1:(NumMiceFolders)
    
   subplot(2, 2, i); 
   
    RightHits = AllRightHitFracs(:, i); 
    RightHits = nonzeros(RightHits); 
    
    LeftHits = AllLeftHitFracs(:, i); 
    LeftHits = nonzeros(LeftHits); 
    
    RightFAs = AllRightFAFracs(:, i); 
    RightFAs = nonzeros(RightFAs); 
    
    LeftFAs = AllLeftFAFracs(:, i); 
    LeftFAs = nonzeros(LeftFAs); 
    
     MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
    if NumDays == 1
        
        plot(RelativeDays, RightHits, 'r-o', RelativeDays,  LeftHits, 'r--x', RelativeDays, RightFAs, 'k-o', RelativeDays, LeftFAs, 'k--x');
        title(MouseName); 
        hold on;
        
    else 
        
    plot(RelativeDays, RightHits, 'r-o', RelativeDays,  LeftHits, 'r--o', RelativeDays, RightFAs, 'k-o', RelativeDays, LeftFAs, 'k--o');
    title(MouseName); 
    hold on; 
    
    end
 
   if i == 2
       
      legend('Right Cued Hits', 'LeftCued Hits', 'Right Cued False Alarms','Left Cued False Alarms' , 'Location','northoutside', 'Orientation','horizontal'); 
   end   
    
end 

NotCuedHitsAndFAs = figure('name', 'Not Cued Hits and False Alarms Rates')

for i = 1:(NumMiceFolders)
    
   subplot(2, 2, i); 
   
    NotHits = AllNotHitFracs(:, i); 
    NotHits = nonzeros(NotHits); 
    
    NotFAs = AllNotFAFracs(:, i); 
    NotFAs = nonzeros(NotFAs);  
    
     MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
        
    plot(RelativeDays, NotHits, 'r-o', RelativeDays,  NotFAs, 'k-o');
    title(MouseName); 
    hold on; 
    
 
   if i == 2
       
      legend('Not Cued Hits', 'Not Cued False Alarms' , 'Location','northoutside', 'Orientation','horizontal'); 
   end   
    
end 

AllCuedHits = figure('name', 'All Cued Hit Rates')

for i = 1:(NumMiceFolders)
    
   subplot(2, 2, i); 
   
    RightHits = AllRightHitFracs(:, i); 
    RightHits = nonzeros(RightHits); 
    
    LeftHits = AllLeftHitFracs(:, i); 
    LeftHits = nonzeros(LeftHits);  
   
   NotHits = AllNotHitFracs(:, i); 
    NotHits = nonzeros(NotHits); 
   
    
     MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
        
    plot(RelativeDays, RightHits, 'r-o', RelativeDays, LeftHits, '-o', RelativeDays, NotHits, 'k-o');
    title(MouseName); 
    hold on; 
    
 
   if i == 2
       
      legend('Right Cued Hits', 'Left Cued Hits', 'Not Cued Hits' , 'Location','northoutside', 'Orientation','horizontal'); 
   end   
    
end 


AllCuedFAs = figure('name', 'All Cued False Alarm Rates')

for i = 1:(NumMiceFolders)
    
   subplot(2, 2, i); 
   
    RightFAs = AllRightFAFracs(:, i); 
    RightFAs = nonzeros(RightFAs); 
    
    LeftFAs = AllLeftFAFracs(:, i); 
    LeftFAs = nonzeros(LeftFAs);  
   
   NotFAs = AllNotFAFracs(:, i); 
    NotFAs = nonzeros(NotFAs); 
   
    
     MouseDates = nonzeros(Dates(:, i)); 
    NumDays = length(MouseDates) ; 
    RelativeDays = zeros(NumDays, 1); 
    
    for x = 1:NumDays
    
    RelativeDayNum = MouseDates(x, 1) - MouseDates(1, 1); 
    RelativeDays(x, 1) =  RelativeDayNum; 
    
    end 
           
    MouseName = MouseNames(1, i); 
    
        
    plot(RelativeDays, RightFAs, 'r-o', RelativeDays, LeftFAs, '-o', RelativeDays, NotFAs, 'k-o');
    title(MouseName); 
    hold on; 
    
 
   if i == 2
       
      legend('Right Cued FAs', 'Left Cued FAs', 'Not Cued FAs' , 'Location','northoutside', 'Orientation','horizontal'); 
   end   
    
end 
