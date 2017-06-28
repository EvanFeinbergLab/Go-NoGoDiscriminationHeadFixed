CodePath = 'C:\Users\Feinberg Lab- Matlab\Documents'; 
DataPath = 'D:\Brooke\Data'; 
cd(DataPath); 
        
MiceFiles = dir(DataPath); 
NumMiceFiles = length(MiceFiles);   
PathsToAnalyze = cell.empty; 


for i = 3:NumMiceFiles
    
    i; 
    cd(DataPath);
    MouseFolder = MiceFiles(i).name;
    BHfile = findstr(MouseFolder, 'BH'); 
    
    if isempty(BHfile) == 0
    
    addpath(MouseFolder); 
    MouseFolderDataPath = strcat(pwd, '\', MouseFolder); 
    cd(MouseFolderDataPath); 
    MouseFolderFiles = dir(MouseFolderDataPath); 
    NumDateFiles = length(MouseFolderFiles); 
    Dates = zeros((NumDateFiles-2), 1); 
    NameAndDate = cell((NumDateFiles-2), 2); 
    
    for x = 3:NumDateFiles
        
        DateFile = MouseFolderFiles(x).name; 
        DateFilePath = strcat(MouseFolderDataPath, '\', DateFile);
           
    %sort files in order of date 
        
    FirstComma = findstr(DateFilePath, ','); 
    StartDateString = FirstComma(1) + 2; 
    
    FindEnd = findstr(DateFilePath, 'PM');
    
    if isempty(FindEnd) == 1
         FindEnd = findstr(DateFilePath, 'AM');
    end 
    
    EndDateString = FindEnd-5; 
    DateString = DateFilePath(StartDateString:EndDateString); 
    
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
    
    Dates((x-2), 1) = DateNum; 
    
    DateCell = cellstr(DateNumString); 
    NameCell = cellstr(DateFile); 
    
    NameAndDate((x-2), 1) = DateCell; 
    NameAndDate((x-2), 2) = NameCell;
     
    end
   
    AscendDates = sort(Dates); 
    NumDates = length(Dates); 
    AscendFiles = cell(NumDates, 1); 
    
    for x = 1:NumDates 
        
        FindIt = find(Dates == AscendDates(x));
        AscendFiles(x, 1) = NameAndDate(FindIt, 2); 
    end
    
    AscendFiles = char(AscendFiles);
    ItNums = zeros(NumDates, 1);
     cd(MouseFolderDataPath); 
    
    for x = 1:NumDates 
                  
        FirstChar = AscendFiles(x, 1); 
        SecondChar = AscendFiles(x, 2);
        IsNum = str2num(FirstChar);
        IsNumTwo = str2num(SecondChar);
        
        if isempty(IsNumTwo) == 0
            
            TwoDigits = strcat(FirstChar, SecondChar); 
            IsNum = str2num(TwoDigits); 
            
        end 

        if isempty(IsNum) == 0 
        
            if IsNum ~= x
                
                OldName = AscendFiles(x, :); 
                OldNamePath = strcat(MouseFolderDataPath, '\', OldName); 
                AscendFiles(x, 1) = num2str(x); 
                RevisedName = AscendFiles(x, :);
                RevisedNamePath = strcat(MouseFolderDataPath, '\',RevisedName); 
                movefile(OldNamePath, RevisedName);
            end 
        
        else 
            
        OldName = AscendFiles(x, :); 
        OldNamePath = strcat(MouseFolderDataPath, '\', OldName);  
        ItString = num2str(x); 
        NewName = strcat(ItString, AscendFiles(x, :));
        NewNamePath = strcat(MouseFolderDataPath, '\', NewName); 
       
        movefile(OldNamePath, NewNamePath);            

        end
        
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
 AllFlashes = single.empty(500000, 0);
 
   
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
Flashes = StimPos(:, 11);


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
    AllFlashes(1:movnu) = Flashes;
    
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
    AllFlashes(StartFill: (StartFill+movnu) - 1) = Flashes;
     
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
Flashes = AllFlashes'; 
TotalDist = AllDist';
[r c] = size(TotalDist); 


TotalLength = length(Stims); 
Velocity = zeros(TotalLength, 1);
DeltaDists = zeros(TotalLength, 1); 
DeltaTimes = zeros(TotalLength, 1); 

for i = 2:(TotalLength-1) 
    
%instant running speed 

DeltaDist = TotalDist((i+1), 1) - TotalDist((i-1), 1); 
DeltaTime = Timer((i+1), 1)- Timer((i-1), 1); 
Velocity(i, 1) = DeltaDist / DeltaTime; 

DeltaDists(i, 1) = DeltaDist; 
DeltaTimes(i, 1) = DeltaTime; 

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
StimIts = zeros(NumStim, 1); 

for i = 1:NumStim 
    
    if i == 1 
        StimIts(i, 1) = VertStimNum(i);  

    else
        if VertStimNum(i)-VertStimNum(i-1) < 10
        StimIts(i, 1) = 0; 
    else 
        StimIts(i, 1) = VertStimNum(i);
    end 
    end 
end 

StimIts = nonzeros(StimIts);   
NumVertStim = length(StimIts); 

%separate according to left or right cue or no cue side 

RightCuedVert = zeros(NumVertStim, 1); 
LeftCuedVert = zeros(NumVertStim, 1);
NotCuedVert = zeros(NumVertStim, 1); 

for i = 1:NumVertStim
    
    StimIt = StimIts(i) ; 
    
    StimCueSide = CueSide(StimIt:StimIt+5); 
    StimCueSide = mode(StimCueSide); 
    
    if StimCueSide == 2 %left side 
        
        LeftCuedVert(i, 1) = StimIt; 
        
    end 
        
    if StimCueSide == 1 %right side 
            
           RightCuedVert(i, 1) = StimIt;
            
    end 
    
      if StimCueSide == 3 %right side 
            
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

for i = 1:NumDiagStim
    
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
    EndWindowTime = StimTime + 0.5; 
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

RightHitRate = NumRightHits/NumRCuedVert; 

RightHitLatencies = nonzeros(RightHitLatencies); 
AvgRHitTime = mean(RightHitLatencies)*1000 


RightCuedFAs = zeros(NumRCuedDiag, 1); 

for i = 1: NumRCuedDiag
    
    StimIt = RightCuedDiag(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.5; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if length(Licked) > 0 %isempty(Licked) == 0
        
        RightCuedFAs(i, 1) = StimIt; 
        
    end    
    
end 

RightCuedFAs = nonzeros(RightCuedFAs); 
NumRightFAs = length(RightCuedFAs) 

RightFARate = NumRightFAs/NumRCuedDiag; 

%lick analysis for left cued 

LeftCuedHits = zeros(NumLCuedVert, 1); 
LeftHitLatencies = zeros(NumLCuedVert, 1); 

for i = 1: NumLCuedVert
    
    StimIt = LeftCuedVert(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.5; 
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

LeftHitRight = NumLeftHits/NumLCuedVert; 

LeftHitLatencies = nonzeros(LeftHitLatencies); 
AvgLHitTime = mean(LeftHitLatencies)*1000


LeftCuedFAs = zeros(NumLCuedDiag, 1); 

for i = 1: NumLCuedDiag
    
    StimIt = LeftCuedDiag(i); 
    
    StimTime = Timer(StimIt); 
    EndWindowTime = StimTime + 0.5; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    
    Licked = find(Licks(StimIt:EndWindowIt) == 1); 
    
    if length(Licked) > 0 %isempty(Licked) == 0
        
        LeftCuedFAs(i, 1) = StimIt; 
        
    end    
    
end 

LeftCuedFAs = nonzeros(LeftCuedFAs); 
NumLeftFAs = length(LeftCuedFAs); 

LeftFARate = NumLeftFAs/NumLCuedDiag; 



AllStim = [StimIts; AllDiagStim]; 
AllStim = sort(AllStim, 'ascend'); 
NumAllStim = length(AllStim); 

CueLickLat = zeros(NumAllStim, 1); 

% for i = 1:NumAllStim 
%    
%     Stim = AllStim(i); 
%     
%     StimTime = Timer(Stim); 
%     CueBefore = StimTime - .25; 
%     CueTime = find(Timer <= CueBefore); 
%     CueTimeIt = CueTime(end); 
%     
%     LickBeforeStim = find(Licks(CueTimeIt:Stim) == 1); 
%     
%     if isempty(LickBeforeStim) == 0 
%     
%         i
%     FirstLick = LickBeforeStim(1);     
%     FirstLickIt = CueTimeIt + FirstLick - 1; 
%     
%     FirstLickTime = Timer(FirstLickIt); 
%     CueLickLatency = (StimTime -  FirstLickTime) *1000; 
%     
%     CueLickLat(i, 1) = CueLickLatency; 
%     
%     end 
%     
% end
% 
% CueLickAvg = mean(CueLickLat); 


%test for # iterations per 1 ms 
  
    VertIt =  StimIts(3); %iteration of each reward
    StimTime = round(Timer(VertIt), 2) ; %time at that reward occurrence 
    BeforeStim = round((StimTime - 0.1), 2); %1 sec before 
    ItBefore = find(Timer >= BeforeStim);   %iteration of 1 ms before reward 
    ItBefore = ItBefore(1); 
    ItPerMs =  VertIt - ItBefore;   
     

 RevAnalysisSpan = 5; %seconds  % 2 iterations = 1 millisecond 
 FwdAnalysisSpan = 5; 
 RewardAnalysisSpan = RevAnalysisSpan + FwdAnalysisSpan;

 
 NumBlocks = 10; %10 blocks per 1000ms
 IterationsPerSpan = NumBlocks*ItPerMs; 
 RewardAnalysisLength = RewardAnalysisSpan*NumBlocks;
 
 RevAnalysisLength = RevAnalysisSpan*ItPerMs*10; %seconds*milliseconds per* iterations per
 FwdAnalysisLength = FwdAnalysisSpan*ItPerMs*10;
 
 StartSpan=   VertIt- (RevAnalysisLength);
 EndSpan = VertIt+ (FwdAnalysisLength);
  
 SpanLength = EndSpan - StartSpan; 
  
  
%peristimulus and reward lick behavior for all vert 

VertLicksinSpan = zeros(SpanLength, NumVertStim-2); 
VertTimeofSpan = zeros(SpanLength,NumVertStim-2); 
VertSpeedinSpan = zeros(SpanLength,NumVertStim-2); 
VertCorridorColor = zeros(NumVertStim-2, 1); 

AllVertStim = [LeftCuedVert; RightCuedVert; NotCuedVert]; 
AllVertStim = sort(AllVertStim, 'ascend'); 


for i = 2:NumVertStim-1 %ignore first and last trial 
    
    VertStim = AllVertStim(i); 
        
    StimTime = Timer(VertStim); 
   
    StartSpan=   VertStim- (RevAnalysisLength);
    EndSpan =  VertStim+ (FwdAnalysisLength); 
    
    SpanLength = EndSpan - StartSpan;   %span of iterations before and after

    VertLicksinSpan(:, i) = Licks((StartSpan+1):EndSpan);
    VertSpeedinSpan(:, i) = Velocity((StartSpan+1):EndSpan);
    VertTimeofSpan(:, i) = Timer((StartSpan+1):EndSpan);  
    
    for y = 1:SpanLength
         VertTimeofSpan(y, i) = VertTimeofSpan(y, i) - StimTime; 
    end 
    
    VertTimeofSpan(:, i) ;
    VertCorridorColor(i, 1) = 1; %green
    
end


VertLicksinSpan = VertLicksinSpan';  
[r c] = size(VertLicksinSpan); 
VertTimeofSpan = VertTimeofSpan';  
VertSpeedinSpan = VertSpeedinSpan';


%PresentTime = 0.8; %seconds 

% %peristimulus and reward lick behavior for diag stim 

 RevAnalysisSpan = 5; %seconds  % 2 iterations = 1 millisecond 
 FwdAnalysisSpan = 5; 
 RewardAnalysisSpan = RevAnalysisSpan + FwdAnalysisSpan; 
 
 NumBlocks = 10; %10 blocks per 1000ms
 IterationsPerSpan = NumBlocks*ItPerMs; 
 RewardAnalysisLength = RewardAnalysisSpan*NumBlocks;
 
 RevAnalysisLength = RevAnalysisSpan*ItPerMs*10; %seconds*milliseconds per* iterations per
 FwdAnalysisLength = FwdAnalysisSpan*ItPerMs*10;

DiagLicksinSpan = zeros(SpanLength, NumDiagStim -2); 
DiagTimeofSpan = zeros(SpanLength, NumDiagStim -2); 
DiagSpeedinSpan = zeros(SpanLength, NumDiagStim -2); 

AllDiagStim = [LeftCuedDiag; RightCuedDiag; NotCuedDiag]; 
AllDiagStim = sort(AllDiagStim, 'ascend'); 

for i = 2:NumDiagStim-1
    
   DiagStim = AllDiagStim(i);
    
    DiagStimTime = Timer(DiagStim); 
   
    StartSpan=  DiagStim- (RevAnalysisLength);
    EndSpan =DiagStim + (FwdAnalysisLength); 
    
    SpanLength = EndSpan - StartSpan;   %span of iterations before and after

         DiagLicksinSpan(:, i) = Licks((StartSpan+1):EndSpan);
         DiagSpeedinSpan(:, i) = Velocity((StartSpan+1):EndSpan);
         DiagTimeofSpan(:, i) = Timer((StartSpan+1):EndSpan);  
         
         for y = 1:SpanLength
            
         DiagTimeofSpan(y, i) = DiagTimeofSpan(y, i) - DiagStimTime; 
         
         end 
    
    DiagTimeofSpan(:, i); 
        
end

DiagLicksinSpan = DiagLicksinSpan';
DiagTimeofSpan = DiagTimeofSpan'; 
DiagSpeedinSpan = DiagSpeedinSpan'; 






CurrentDir = pwd; 
FindStart = findstr(CurrentDir, 'BH'); 
SaveString = CurrentDir(FindStart:end); 
MouseName = CurrentDir(FindStart:FindStart+4);
Date = CurrentDir(FindStart+6:end);

AnalyzedPath = strcat(CodePath, '\', 'Analyzed');
cd(AnalyzedPath); 

if exist(MouseName, 'dir') == 0 
    
    mkdir('Analyzed', MouseName); 
    
end 

MousePath = strcat(CodePath, '\', 'Analyzed', '\', MouseName); 
DatePath = strcat(MousePath, '\', Date); 

if exist(DatePath, 'dir') == 0 
    
    mkdir(MouseName, Date); 
end 

SavePath = strcat(CodePath, '\', 'Analyzed', '\', SaveString); 
cd(SavePath); 

FindSeshNum = findstr(SavePath, '\'); 
FindSeshNum = FindSeshNum(end); 
SeshNumIt = FindSeshNum + 1; 
SeshNum = strcat('Session', SavePath(SeshNumIt)); 


 XLabel = 'Peristimulus Time (s)';
YLabel = 'Trial'; 

Trials = (1:NumVertStim);
VertTrialsOne = figure('name','Vertical Trials Part1'); 
 

for i = 1:round((NumVertStim/2)) 
    
    i;    
    x = VertTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
      
    hold on; 
       
    VertIt = AllVertStim(i);    
    
    SideOfCue = find(RightCuedVert == VertIt); 
    
    if isempty(SideOfCue) == 0
        
          Color = [0 0.75 0]; %green 
    end 
        
     if isempty(SideOfCue) == 1
       
         OtherSideOfCue = find(LeftCuedVert == VertIt); 
         
          if isempty(OtherSideOfCue) == 0
              
         Color = [0 0.75 1]; %blue    
         
          end
          
          if isempty(OtherSideOfCue) == 1
              
           Color = [1 1 .25]; %yellow?   
         
          end
    end 
    
    StimTime = Timer(VertIt); 
    StartWindowTime = 0; 
    EndWindowTime = StimTime + 0.8; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    %EndWindowTime = Timer(EndWindowIt) - StimTime; 
            
     RZSpan = [StartWindowTime 0.8]; 
     Ys = [y y]; 
               
     plot(RZSpan, Ys, 'Color', Color , 'LineWidth', 3);   
 
     Title = strcat(MouseName, '-', SeshNum, ':', 'Vertical Trials Part1'); 
     title(Title); 
     xlabel(XLabel); 
     ylabel(YLabel); 
     
  hold on; 
    
    for a = 1:SpanLength
               
        LickPresent = VertLicksinSpan(i, a);  
        
        if LickPresent == 1
            
            LickTime = VertTimeofSpan(i, a); 
            plot(LickTime, y, 'k.', 'MarkerSize', 10);
            
        end 
    end 
    
    hold on; 
     

       RewardLick = find(Licks(VertIt:EndWindowIt) == 1); 
       
       if isempty(RewardLick) == 0
           
       Reward = RewardLick(1); 
       RewardIt = (VertIt + Reward) - 1; 
       RewardTime = Timer(RewardIt)-StimTime;    
       plot(RewardTime, y, 'r.', 'MarkerSize', 12);
          
       end 
 
end  

FigureSaveName = 'Vert_Trials_Part1.png'; 
saveas(gcf, FigureSaveName); 
close(VertTrialsOne); 




VertTrialTwo = figure('name','Vert Trials Part2'); 
  
 for i = (round(NumVertStim/2)+1): NumVertStim-2
    
     
       
    i;    
    x = VertTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
      
    hold on; 
       
    VertIt = AllVertStim(i);    
    
    SideOfCue = find(RightCuedVert == VertIt); 
    
    if isempty(SideOfCue) == 0
        
          Color = [0 0.75 0]; %green = right
          
    end 
        
    if isempty(SideOfCue) == 1
       
             OtherSideOfCue = find(LeftCuedVert == VertIt); 
         
          if isempty(OtherSideOfCue) == 0
              
         Color = [0 0.75 1]; %blue    
         
          end
          
          if isempty(OtherSideOfCue) == 1
              
           Color = [1 1 0.25]; %yellow?   
         
          end
    end 
    
    StimTime = Timer(VertIt); 
    StartWindowTime = 0; 
    EndWindowTime = StimTime + 0.5; 
    EndWindowIt = find(Timer <= EndWindowTime); 
    EndWindowIt = EndWindowIt(end); 
    %EndWindowTime = Timer(EndWindowIt) - StimTime; 
            
     RZSpan = [StartWindowTime 0.8]; 
     Ys = [y y]; 
               
     plot(RZSpan, Ys, 'Color', Color , 'LineWidth', 3);   
 
     Title = strcat(MouseName, '-', SeshNum, ':', 'Vertical Trials Part2'); 
     title(Title); 
     xlabel(XLabel); 
     ylabel(YLabel); 
     
  hold on; 
    
    for a = 1:SpanLength
               
        LickPresent = VertLicksinSpan(i, a);  
        
        if LickPresent == 1
            
            LickTime = VertTimeofSpan(i, a); 
            plot(LickTime, y, 'k.', 'MarkerSize', 10);
            
        end 
    end 
    
    hold on; 
     

       RewardLick = find(Licks(VertIt:EndWindowIt) == 1); 
       
       if isempty(RewardLick) == 0
           
       Reward = RewardLick(1); 
       RewardIt = (VertIt + Reward) - 1; 
       RewardTime = Timer(RewardIt)-StimTime;    
       plot(RewardTime, y, 'r.', 'MarkerSize', 12);
          
       end   
end  


FigureSaveName = 'Vert_Trials_Part2.png'; 
saveas(gcf, FigureSaveName); 
close(VertTrialTwo); 



Trials = (1:NumDiagStim);
YLabel = 'Trial'; 

DiagTrialsOne = figure('name','Diag Trials Part1'); 

for i = 1:round((NumDiagStim/2)) 
    
   
    x = DiagTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
       
    hold on;     
     
    DiagStimIt = AllDiagStim(i);
    SideOfCue = find(RightCuedDiag == DiagStimIt); 
       
    
    if isempty(SideOfCue) == 0
        
          Color = 'r'; %[1 0 0]; % red = right
          
    end 
        
    if isempty(SideOfCue) == 1
       
          OtherSideOfCue = find(LeftCuedDiag == DiagStimIt); 
         
          if isempty(OtherSideOfCue) == 0
              
         Color = 'm'; %[1 0 1];  %   
         
          end
          
          if isempty(OtherSideOfCue) == 1
              
          %y = [1 1 0.25];  %yellow? 
          Color = 'y'; 
         
          end
    end  
       
     StimTime = Timer(DiagStimIt); 
    StartWindowTime = 0; 
    EndWindow = StimTime + 0.8; 
    EndWindowIt = find(Timer >= EndWindow); 
    EndWindowIt = EndWindowIt(1); 
    EndWindowTime = Timer(EndWindowIt) - StimTime; 
            
     DiagStimSpan = [StartWindowTime 0.8]; 
     Ys = [y y];   
    
    plot(DiagStimSpan, Ys, Color, 'LineWidth', 3);       
    
        for z = 1:SpanLength
        
        LickPresent = DiagLicksinSpan (i, z);  
        
        if LickPresent == 1
            
            LickTime = DiagTimeofSpan(i, z); 
            plot(LickTime, y, 'k.', 'MarkerSize', 8);
            
        end 
        end  
    
        hold on; 
        
         Title = strcat(MouseName, '-', SeshNum, ':', 'Diagonal Trials Part1'); 
        title(Title); 
        xlabel(XLabel); 
        ylabel(YLabel);
    
end 

FigureSaveName = 'Diag_Trials_Part1.png'; 
saveas(gcf, FigureSaveName); 
close(DiagTrialsOne); 



DiagTrialsTwo = figure('name','DiagTrials Part2'); 

for i = round((NumDiagStim/2))+1 : NumDiagStim-2 
   
 
    x = DiagTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
       
    hold on;     
     
    DiagStimIt = AllDiagStim(i);
    SideOfCue = find(RightCuedDiag == DiagStimIt); 
       
    if isempty(SideOfCue) == 0
        
          Color = 'r'; % red = right
          
    end 
        
    if isempty(SideOfCue) == 1
       
          OtherSideOfCue = find(LeftCuedVert == DiagStimIt); 
         
          if isempty(OtherSideOfCue) == 0
              
         Color = 'm';  %blue    
         
          end
          
          if isempty(OtherSideOfCue) == 1
              
          Color = 'y';    
         
          end
    end  
       
     StimTime = Timer(DiagStimIt); 
    StartWindowTime = 0; 
    EndWindow = StimTime + 0.8; 
    EndWindowIt = find(Timer >= EndWindow); 
    EndWindowIt = EndWindowIt(1); 
    EndWindowTime = Timer(EndWindowIt) - StimTime; 
            
     DiagStimSpan = [StartWindowTime 0.8]; 
     Ys = [y y];   
    
    plot(DiagStimSpan, Ys, Color, 'LineWidth', 3);       
    
        for z = 1:SpanLength
        
        LickPresent = DiagLicksinSpan (i, z);  
        
        if LickPresent == 1
            
            LickTime = DiagTimeofSpan(i, z); 
            plot(LickTime, y, 'k.', 'MarkerSize', 8);
            
        end 
        end  
    
        hold on; 
        
         Title = strcat(MouseName, '-', SeshNum, ':', 'Diagonal Trials Part1'); 
        title(Title); 
        xlabel(XLabel); 
        ylabel(YLabel);
    
       
end  

FigureSaveName = 'Diag_Trials_Part2.png'; 
saveas(gcf, FigureSaveName); 
close(DiagTrialsTwo); 







YLabel = 'Speed (cm/s)'; 

%avg speed of trials 


RCueVertAvgSpeed = zeros(NumVertStim, SpanLength); 
LCueVertAvgSpeed = zeros(NumVertStim, SpanLength); 

for i = 2:NumVertStim-2
    
    AvgVertSpeed = VertSpeedinSpan(i, :); 
    
    VertIt = AllVertStim(i);
    
   SideOfCue = find(RightCuedVert == VertIt); 
    
    if isempty(SideOfCue) == 0  %is default
       
        RCueVertAvgSpeed(i, :) = AvgVertSpeed; 
        
    else %is variant 
        
        LCueVertAvgSpeed(i, :) =  AvgVertSpeed; 
        
    end 
    
end 

LCueVertAvgSpeed = mean(LCueVertAvgSpeed, 1);
RCueVertAvgSpeed = mean(RCueVertAvgSpeed, 1);

LCueVertAvgSpeed = LCueVertAvgSpeed'; 
RCueVertAvgSpeed = RCueVertAvgSpeed';

x = VertTimeofSpan(2, :); 

VertAvgSpeed = figure('name', 'Average Speed For Vert Stim in Session'); 
plot(x, RCueVertAvgSpeed, x, LCueVertAvgSpeed); 
hold on; 

legend('Right Cued Vert Stim', 'Left Cued Vert Stim'); 
Title = strcat(MouseName, '-', SeshNum, ':', 'Average Speed For Vert Stim In Session'); 
title(Title); 
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Speed_For_Vert_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(VertAvgSpeed); 




YLabel = 'Average Licks'; 

 YLabel = 'Average Licks'; 
 
RCueVertAvgLicks = zeros(NumVertStim, SpanLength); 
LCueVertAvgLicks = zeros(NumVertStim, SpanLength); 


for i = 2:NumVertStim-2
    
    AvgVertLicks = VertLicksinSpan(i, :); 
    
    VertIt = AllVertStim(i);
    
    SideOfCue = find(RightCuedVert == VertIt); 
    
    if isempty(SideOfCue) == 0  %is default
       
        RCueVertAvgLicks(i, :) = AvgVertLicks; 
        
    else %is variant 
        
        LCueVertAvgLicks(i, :) =  AvgVertLicks; 
        
    end 
    
end 


LCueVertAvgLicks = smooth(mean(LCueVertAvgLicks, 1));
RCueVertAvgLicks = smooth(mean(RCueVertAvgLicks, 1));

LCueVertAvgLicks = LCueVertAvgLicks'; 
RCueVertAvgLicks = RCueVertAvgLicks';

LeftHitLicks = zeros(NumLeftHits , SpanLength); 
RightHitLicks = zeros(NumRightHits , SpanLength); 

for i = 2:NumRightHits-1

    RHit = RightCuedHits(i); 
    RHitIt = find(AllVertStim == RHit); 
    RightHitLick = VertLicksinSpan(RHitIt-1, :);
    RightHitLicks(i, :) = RightHitLick; 

end

RightHitLicks = smooth(mean(RightHitLicks, 1));

for i = 2:NumLeftHits-1

    LHit = LeftCuedHits(i); 
    LHitIt = find(AllVertStim == LHit); 
    LeftHitLick = VertLicksinSpan(LHitIt-1, :);
    LeftHitLicks(i, :) = LeftHitLick; 

end

LeftHitLicks = smooth(mean(LeftHitLicks, 1));


 

RCueDiagAvgLicks = zeros(NumDiagStim, SpanLength); 
LCueDiagAvgLicks = zeros(NumDiagStim, SpanLength); 


for i = 2:NumDiagStim-2
    
    AvgDiagLicks = DiagLicksinSpan(i, :); 
    
    DiagIt = AllDiagStim(i);
    
    SideOfCue = find(RightCuedDiag == DiagIt); 
    
    if isempty(SideOfCue) == 0  %is default
       
        RCueDiagAvgLicks(i, :) = AvgDiagLicks; 
        
    else %is variant 
        
        LCueDiagAvgLicks(i, :) =  AvgDiagLicks; 
    end 
    
end 

LCueDiagAvgLicks = smooth(mean(LCueDiagAvgLicks, 1));
RCueDiagAvgLicks = smooth(mean(RCueDiagAvgLicks, 1));

LCueDiagAvgLicks = LCueDiagAvgLicks'; 
RCueDiagAvgLicks = RCueDiagAvgLicks'; 



LeftFALicks = zeros(NumLeftFAs , SpanLength); 
RightFALicks = zeros(NumRightFAs , SpanLength); 

for i = 2:NumRightFAs-1

    RFA = RightCuedFAs(i); 
    RFAIt = find(AllDiagStim == RFA); 
    RightFALick = DiagLicksinSpan(RFAIt-1, :);
    RightFALicks(i, :) = RightFALick; 

end

RightFALicks = smooth(mean(RightFALicks, 1));

for i = 2:NumLeftFAs-1

    LFA = LeftCuedFAs(i); 
    LFAIt = find(AllDiagStim == LFA); 
    LeftFALick = DiagLicksinSpan(LFAIt-1, :);
    LeftFALicks(i, :) = LeftFALick; 

end

LeftFALicks = smooth(mean(LeftFALicks, 1));



%lick behavior for right and left cued FAs and Hits

x = DiagTimeofSpan(2, :); 
x = x'; 

DiagAvgLicks = figure('name', 'Average Licks For Hits and False Alarms'); 
 subplot(2, 1, 1); 
plot(x, RightHitLicks, 'r-', x, RightFALicks, 'k-'); 
legend('Right Cued Hit Licking', 'Right Cued FA Licking'); 
hold on; 

 subplot(2, 1, 2); 
plot(x, LeftHitLicks, 'r-', x, LeftFALicks, 'k-'); 
legend('Left Cued Hit Licking', 'Left Cued FA Licking'); 
hold on;

Title = strcat(MouseName, '-', SeshNum, ':', 'Average Licks For Hits and False Alarms In Session'); 
title(Title);
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Licks_For_Hits_ And_False_Alarms_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(DiagAvgLicks); 



x = VertTimeofSpan(2, :); 
x = x'; 

VertAvgLicks = figure('name', 'Average Licks For Vert Stim In Session'); 
plot(x, RCueVertAvgLicks, x, LCueVertAvgLicks); 
hold on; 

legend('Right Cued Vert Stim', 'Left Cued Vert Stim'); 
Title = strcat(MouseName, '-', SeshNum, ':', 'Average Licks For Vert Stim In Session'); 
title(Title); 
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Licks_For_Vert_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(VertAvgLicks); 






x = DiagTimeofSpan(2, :); 
x = x'; 

DiagAvgLicks = figure('name', 'Average Licks For Diag Stim In Session'); 
plot(x, RCueDiagAvgLicks, x, LCueDiagAvgLicks); 
hold on; 

legend('Right Cued Diag Stim', 'Left Cued Diag Stim'); 
Title = strcat(MouseName, '-', SeshNum, ':', 'Average Licks For Diag Stim In Session'); 
title(Title); 
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Licks_For_Diag_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(DiagAvgLicks); 



YLabel = 'Speed (cm/s)'; 

%avg speed of trials 


RCueDiagAvgSpeed = zeros(NumDiagStim, SpanLength); 
LCueDiagAvgSpeed = zeros(NumDiagStim, SpanLength); 

for i = 2:NumDiagStim-2
    
    AvgDiagSpeed = DiagSpeedinSpan(i, :); 
    
    DiagIt = AllDiagStim(i);
    
   SideOfCue = find(RightCuedDiag == DiagIt); 
    
    if isempty(SideOfCue) == 0  %is default
       
        RCueDiagAvgSpeed(i, :) = AvgDiagSpeed; 
        
    else %is variant 
        
        LCueDiagAvgSpeed(i, :) =  AvgDiagSpeed; 
        
    end 
    
end 

LCueDiagAvgSpeed = smooth(mean(LCueDiagAvgSpeed, 1));
RCueDiagAvgSpeed = smooth(mean(RCueDiagAvgSpeed, 1));

LCueDiagAvgSpeed = LCueDiagAvgSpeed'; 
RCueDiagAvgSpeed = RCueDiagAvgSpeed';

x = DiagTimeofSpan(2, :); 

DiagAvgSpeed = figure('name', 'Average Speed For Diag Stim in Session'); 
plot(x, RCueDiagAvgSpeed, x, LCueDiagAvgSpeed); 
hold on; 

legend('Right Cued Diag Stim', 'Left Cued Diag Stim'); 
Title = strcat(MouseName, '-', SeshNum, ':', 'Average Speed For Diag Stim In Session'); 
title(Title); 
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Speed_For_Diag_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(DiagAvgSpeed); 






cd(AnalysisPath); 
AccessPath = strcat(AnalysisPath, '\', 'FolderAccessed'); 
savepath AccessPath.txt; 

    
end 



   



