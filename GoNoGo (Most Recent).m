CodePath = 'C:\Users\Feinberg Lab- Matlab\Documents'; 
DataPath = 'D:\Brooke\Data\Discrim Tasks\Discrim Only'; 
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

movnu = movbytsize/(10*4+8);

if rem(movnu, 1) == 0 

TotalFrames(x, 1) = movnu; 
%red stamp, PCO it, eye it, elapsed time, eye track, stim & position, movie

fseek(movfile, 10*4 ,'bof');
Timer = zeros(movnu, 1);

for y = 1:movnu

    Time = fread(movfile, 1 , 'double', 0, 'ieee-be'); %
    Timer(y, 1)= Time; 
    fseek(movfile,10*4,'cof');
   
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
StimPos = zeros(movnu, 11);  
Zeros = zeros(1, 11); 

for y = 1:movnu
    
    Stiminfo = fread(movfile, 10 ,'single',0,'ieee-be');  
    StimInfo = Stiminfo';
    StimPos(y, 1:10)= StimInfo;
     
    StimPos(y, 11) = y; 
    
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

%finds occurences of  all stimuli
AllNumStim = find((Stims(:, 1) > 0));   
AllStimNum = length(AllNumStim); 
AllStimIts = zeros(AllStimNum, 1); 

for i = 1:AllStimNum 
    
    if i == 1 
        AllStimIts(i, 1) = AllNumStim(i);  

    else
        if AllNumStim(i)- AllNumStim(i-1) < 10
        AllStimIts(i, 1) = 0; 
    else 
        AllStimIts(i, 1) = AllNumStim(i);
    end 
    end 
end 

AllStimIts = nonzeros(AllStimIts);  
AllStimNum = length(AllStimIts);

TotalTime = Timer(end) - Timer(1);

StimPeriodicity = TotalTime/AllStimNum; 


%find deriv/change in value of licks 

derivLicks = diff(Licks); 
NumDiffLicks = length(derivLicks); 

DerivLicks  = abs(derivLicks); 
DerivLicks = [0; DerivLicks]; 
%Licks = DerivLicks; 

% occurrences of lick windows 

Windows = find(RZDist > 100); 
NumWindows = length(Windows); 
LickWindows = zeros(NumWindows, 1); 

for i = 1:NumWindows
    
    if i == 1 
   LickWindows(i, 1) = Windows(i);  

    else
        if  Windows (i)-  Windows (i-1) == 1
         LickWindows(i, 1) = 0; 
    else 
         LickWindows(i, 1) =  Windows(i);
    end 
    end 
end 

 LickWindows = nonzeros(LickWindows); 
NumLickWindows = length(LickWindows)

%occurrences of RZ starts and ends 

RZ = find(RZDist ~= 0); 
NumRZ = length(RZ); 
RZs = zeros(NumRZ, 1); 

for i = 1:NumRZ
    
    if RZDist(i) < 100 
                   
        if i == 1 
       RZs(i, 1) = RZ (i);  

        else
            if RZ (i)- RZ (i-1) == 1
            RZs(i, 1) = 0; 
        else 
            RZs(i, 1) = RZ (i);
        end 
        end 
        
    else 
        
       RZs(i, 1) = 0; 
       
    end 
        
end 

RZs = nonzeros(RZs); 
NumRZs = length(RZs); 

%get rid of ones that are actually lick windows 

for i =  1:NumRZs
    
    RZAfter = RZs(i)+5 ;
    RZDistAfter = RZDist(RZAfter); 
    
    if RZDistAfter > 100 
        
        RZs(i, 1) = 0; 
        
    end
    
end 

RZs = nonzeros(RZs); 
NumRZs = length(RZs); 


%get rid of repeat starts -- toggling at beginning of RZ
tempRZs = zeros(NumRZs, 1); 

for i = 1:NumRZs
    
    if i == 1 
    tempRZs(i, 1) = RZs (i);  

    else
        if RZs (i)- RZs (i-1) < 100
        tempRZs(i, 1) = 0; 
    else 
        tempRZs(i, 1) = RZs (i);
    end 
    end 
end 

RZs = nonzeros(tempRZs); 
NumRZs = length(RZs);

tempRZs = zeros(NumRZs, 1); 

for i= 1:NumRZs
    
    RZValue = RZDist(RZs(i)); 
    RZValueBefore = RZDist(RZs(i) - 1); 
    
    if RZValueBefore == 0 && RZValue < 5; 
        
      tempRZs(i, 1) = RZs(i); 
      
    end 
    
    
end 

RZs = nonzeros(tempRZs); 
NumRZs = length(RZs); 

MaxRZDist = max(RZDist); 
if MaxRZDist > 70 
    
    MaxRZDist = 70; 
    
end 

RZStarts = zeros((NumRZs-2), 1); 
RZEnds = zeros((NumRZs-2), 1); 

for i = 2:(NumRZs-1) %ignore first and last trial 
    
    i; 
    if i == NumRZs
        
    RZValues = RZDist(RZs(i): end);
        
    else 
    
    RZValues = RZDist(RZs(i): RZs(i+1)-1);
    end 
        
    SearchRZStart = find(RZValues >= 30) ;
    if isempty(SearchRZStart) == 0
        
    Start = SearchRZStart(1); 
    RZStart = RZs(i)+(Start-1);
    RZStarts(i, 1) = RZStart; 
    
    end
   
    SearchRZEnd = find(RZValues >= MaxRZDist); 
    
    if isempty(SearchRZEnd) == 0 
        
    End = SearchRZEnd(1); 
    RZEnd = RZs(i)+(End-1);
    RZEnds(i, 1) = RZEnd; 
    
    end
end 

RZStarts;
RZStarts = nonzeros(RZStarts); 
NumStarts = length(RZStarts); 
RZEnds = nonzeros(RZEnds); 
NumEnds = length(RZEnds);  

%elim early starts

EarlyStarts = find(RZStarts < RZEnds(1)); 
FirstStart = EarlyStarts(end); 
NumEarlyStarts = length(EarlyStarts); 

for i = 1:(NumEarlyStarts-1) 
    
    RZStarts(i) = 0; 
    
end 

RZStarts = nonzeros(RZStarts); 
NumStarts = length(RZStarts); 



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
StimIts(1) = 0;
StimIts(end) = 0;
StimIts = nonzeros(StimIts); 
NumVertDefaults = length(StimIts); 

VertStimLength = zeros(NumVertDefaults, 1); 
VertStimSide = zeros(NumVertDefaults, 1); 
VertCueSide = zeros(NumVertDefaults, 1); 
VertStimMotion = zeros(NumVertDefaults, 1); 


for i = 1:NumVertDefaults 
    
    VertStimLength(i, 1) = StimLength(StimIts(i), 1); 
    VertStimSide(i, 1) = StimSide(StimIts(i), 1);
    VertCueSide(i, 1) = CueSide(StimIts(i), 1);
    VertStimMotion(i, 1) = StimMotion(StimIts(i), 1);

end 

VertDefaultIts = StimIts; 
VertVariantIts = LickWindows; 



%discarding early info  

StartAtFirstRZ = find(VertDefaultIts < RZStarts(1)); 
NumEarlyStims = length(StartAtFirstRZ); 
for i = 1:(NumEarlyStims - 1) 
    
    VertDefaultIts(i) = 0;    
end 
VertDefaultIts = nonzeros(VertDefaultIts); 


    StartsBefore = find(RZStarts < VertDefaultIts(1)); 
    NumStartsBefore = length(StartsBefore); 
    
    for i = 1: (NumStartsBefore)
        
        RZStarts(i) = 0;        
    end 
    
    RZStarts = nonzeros(RZStarts); 
    NumStarts = length(RZStarts); 


%discarding info after the last RZStart

if StimIts(end) > RZStarts(end)   
    StimIts(end) = 0;    
end 

VertDefaultIts= nonzeros(VertDefaultIts); 
NumVertDefaults = length(VertDefaultIts); 


%get same num of starts and ends 

 TempStarts = zeros(NumEnds, 1);  

if NumStarts > NumEnds
        
    for i = 1:NumEnds
        
        StartsBefore = find(RZStarts < RZEnds(i));        
        TempStarts(i, 1) = RZStarts(StartsBefore(end), 1); 
        
    end   
    RZStarts = TempStarts; 
    
end 

NumStarts = length(RZStarts);


TempEnds = zeros(NumStarts, 1);  

if NumEnds > NumStarts
    
    for i = 1:NumStarts
        
        if i < NumStarts 
        
        EndsBefore = find(RZEnds < RZStarts(i+1));        
        TempEnds(i, 1) = RZEnds(EndsBefore(end), 1); 
        
        else 
            
         TempEnds(i, 1)=  RZEnds(end);   
        
        end  
    end 
    
    RZEnds = TempEnds;
    
end 
 
NumEnds = length(RZEnds);


%eliminate extra Stims 
if NumVertDefaults > NumStarts 
    
    tempStim = zeros(NumStarts, 1); 

for i = 1:NumStarts
    
    i; 
    LastStim = find(VertDefaultIts < RZStarts(i)); 
    LastStim = LastStim(end); 
    
    tempStim(i, 1) = VertDefaultIts(LastStim); 
end

VertDefaultIts= tempStim; 
end 

    
tempStim = zeros(NumStarts, 1); 
    
for i = 1:NumStarts
        
        StimBefore = find(VertDefaultIts < RZStarts(i)); 
        
        if isempty(StimBefore) == 0 
        StimBefore = StimBefore(end); 
        
         tempStim(i, 1) = VertDefaultIts(StimBefore); 
         
        end 
         
end   
VertDefaultIts = tempStim; 


%finds occurences of reward
RewardIts = zeros(NumStarts, 1); 
Hits = zeros(NumStarts, 1); 


for i = 1: NumStarts 
     
    StartRZ = RZStarts(i); 
    EndRZ = RZEnds(i); 
    
    Span = Licks(StartRZ:EndRZ); 
    LickWithin = find(Span == 1); 
    
    if isempty(LickWithin) == 0
        
        FirstLick = LickWithin(1); 
        FirstLickIt = (FirstLick - 1) + StartRZ; 
    	RewardIts(i, 1) = FirstLickIt;  
        Hits(i, 1) = FirstLickIt;
        
    else
        
        if i < NumStarts
        RewardAfter =  RZDist(EndRZ:RZStarts(i+1)); 
        else 
         RewardAfter =  RZDist(EndRZ:end); 
        end 
        
        %CorridorEnd = max(RewardAfter); 
%         RewardDist = find(RewardAfter == CorridorEnd); 
%         RewardDist = RewardDist(1); 
%         FreeRewardIt = (RewardDist - 1) + EndRZ; 
        FreeRewardIt = EndRZ + 1; 
        RewardIts(i, 1) = FreeRewardIt; 
    end 
end 




RZStarts = nonzeros(RZStarts);
NumStarts = length(RZStarts)  

RZEnds = nonzeros(RZEnds);
NumEnds = length(RZEnds)

RewardIts = nonzeros(RewardIts);
NumReward = length(RewardIts) 

VertDefaultIts = nonzeros(VertDefaultIts);
NumVertDefaults = length(VertDefaultIts)

VertVariantIts = nonzeros(VertVariantIts);
NumVertVariants = length(VertVariantIts); 




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

DiagStimIts = nonzeros(DiagStimIts);
DiagStimIts(1) = 0; %ignore the first trial 
DiagStimIts(end) = 0;
DiagStimIts = nonzeros(DiagStimIts);
NumDiagStim = length(DiagStimIts) 
DiagVariantStim = zeros(NumDiagStim, 1); 
DiagDefaultStim = zeros(NumDiagStim, 1);

for i = 1:NumDiagStim 
    
     DiagVariant = StimLength(DiagStimIts(i)-10, 1); 
     
     if DiagVariant > 0
         
         DiagVariantStim(i, 1) = DiagStimIts(i); 
         
     else 
                  
        DiagDefaultStim(i, 1) =  DiagStimIts(i); 
        
     end 
    
end 

DiagVariantStimIts = nonzeros(DiagVariantStim); 
DiagDefaultStimIts = nonzeros(DiagDefaultStim);
NumDiagVariants = length(DiagVariantStimIts ); 
NumDiagDefaults = length(DiagDefaultStimIts); 

NumDiagStim = NumDiagVariants + NumDiagDefaults; 
NumVertStim = NumVertDefaults + NumVertVariants;  

TotalTrials = NumDiagStim + NumVertStim; 


AllDiagStimIts = [DiagVariantStimIts; DiagDefaultStimIts]; 
AllDiagStimIts = sort(AllDiagStimIts,'descend'); 
NumDiagIts = length(AllDiagStimIts); 

DiagStimIts = zeros(TotalLength, 1); 
for i = 1:NumDiagIts  
    
   DiagIt = AllDiagStimIts(i); 
   DiagStimIts(DiagIt, 1) = 1; 
    
end 


if TotalTrials >= 50 

%test for # iterations per 1 ms 
  
    VertIt =  VertDefaultIts(1); %iteration of each reward
    StimTime = round(Timer(VertIt), 2) ; %time at that reward occurrence 
    BeforeStim = round((StimTime - 0.1), 2); %1 sec before 
    ItBefore = find(Timer >= BeforeStim);   %iteration of 1 ms before reward 
    ItBefore = ItBefore(1); 
    ItPerMs =  VertIt - ItBefore;   
     

 RevAnalysisSpan = 10; %seconds  % 2 iterations = 1 millisecond 
 FwdAnalysisSpan = 40; 
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

LicksSpanReward = zeros(RewardAnalysisLength, 1);
BlockLicks = zeros(RewardAnalysisLength, NumReward);
TimeofLickBlock = zeros(RewardAnalysisLength, NumReward);
VertLicksinSpan = zeros(SpanLength, NumReward); 
VertTimeofSpan = zeros(SpanLength, NumReward); 
VertSpeedinSpan = zeros(SpanLength, NumReward); 

for i = 1:NumVertDefaults
    
    VertDefaultIt =  VertDefaultIts(i);
   
    StartSpan=   VertDefaultIt- (RevAnalysisLength);
    EndSpan =  VertDefaultIt+ (FwdAnalysisLength); 
    
    SpanLength = EndSpan - StartSpan;   %span of iterations before and after
    Blocks = SpanLength/ItPerMs;

    VertLicksinSpan(:, i) = Licks((StartSpan+1):EndSpan);
    VertSpeedinSpan(:, i) = Velocity((StartSpan+1):EndSpan);
    VertTimeofSpan(:, i) = Timer((StartSpan+1):EndSpan);  
    
    for y = 1:SpanLength
         VertTimeofSpan(y, i) = VertTimeofSpan(y, i) - StimTime; 
    end 
    
    VertTimeofSpan(:, i) ;
end

TimeofLickBlock; 
BlockLicks;

VertLicksinSpan = VertLicksinSpan';  
[r c] = size(VertLicksinSpan); 
VertTimeofSpan = VertTimeofSpan';  
VertSpeedinSpan = VertSpeedinSpan';




%peristimulus and reward lick behavior for diag stim 

 RevAnalysisSpan = 10; %seconds  % 2 iterations = 1 millisecond 
 FwdAnalysisSpan = 20; 
 RewardAnalysisSpan = RevAnalysisSpan + FwdAnalysisSpan; 
 
 NumBlocks = 10; %10 blocks per 1000ms
 IterationsPerSpan = NumBlocks*ItPerMs; 
 RewardAnalysisLength = RewardAnalysisSpan*NumBlocks;
 
 RevAnalysisLength = RevAnalysisSpan*ItPerMs*10; %seconds*milliseconds per* iterations per
 FwdAnalysisLength = FwdAnalysisSpan*ItPerMs*10;

LicksSpanReward = zeros(RewardAnalysisLength, 1);
BlockLicks = zeros(RewardAnalysisLength, NumReward);
TimeofLickBlock = zeros(RewardAnalysisLength, NumReward);
DiagLicksinSpan = zeros(SpanLength, NumReward); 
DiagTimeofSpan = zeros(SpanLength, NumReward); 
DiagSpeedinSpan = zeros(SpanLength, NumReward); 

for i = 1:NumDiagDefaults
    
    DiagDefaultStimIt =DiagDefaultStimIts(i);
    
    DiagStimTime = Timer(DiagDefaultStimIt); 
         
   
    StartSpan=  DiagDefaultStimIt- (RevAnalysisLength);
    EndSpan = DiagDefaultStimIt+ (FwdAnalysisLength); 
    
    SpanLength = EndSpan - StartSpan;   %span of iterations before and after

         DiagLicksinSpan(:, i) = Licks((StartSpan+1):EndSpan);
         DiagSpeedinSpan(:, i) = Velocity((StartSpan+1):EndSpan);
         DiagTimeofSpan(:, i) = Timer((StartSpan+1):EndSpan);  
         
         for y = 1:SpanLength
            
         DiagTimeofSpan(y, i) = DiagTimeofSpan(y, i) - DiagStimTime; 
         
         end 
    
    DiagTimeofSpan(:, i); 
end
% 
% TimeofLickBlock; 
% BlockLicks;

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

Trials = (1:NumVertDefaults);
VertTrialsOne = figure('name','Vertical Trials Part1'); 

for i = 1:round((NumVertDefaults/2)) 
    
    i; 
    x = VertTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
      
    hold on; 
       
    VertDefaultIt = VertDefaultIts(i);
    StimTime = Timer(VertDefaultIt);
     
     EndRZ = RZEnds(i);
     RZEndTime = Timer(EndRZ)-StimTime;  
     
     StartRZ = RZStarts(i);
     RZStartTime = Timer(StartRZ)-StimTime;  
     
     RZSpan = [RZStartTime RZEndTime]; 
     Ys = [y y]; 
     
     plot(RZSpan, Ys, 'Color', [0 0.75 0], 'LineWidth', 6);
     Title = strcat(MouseName, '-', SeshNum, ':', 'Vertical Trials Part1'); 
     title(Title); 
     xlabel(XLabel); 
     ylabel(YLabel); 
     
  hold on; 
    
    for a = 1:SpanLength
               
        LickPresent = VertLicksinSpan(i, a);  
        
        if LickPresent == 1
            
            LickTime = VertTimeofSpan(i, a); 
            plot(LickTime, y, 'k.', 'MarkerSize', 8);
            
        end 
    end  
    
    hold on; 
    
     RewardIt = RewardIts(i); 
     RewardTime = Timer(RewardIt)-StimTime; %time at that reward occurrence
     plot(RewardTime, y, 'r.', 'MarkerSize', 16); 
    
end  

FigureSaveName = 'Vert_Trials_Part1.png'; 
saveas(gcf, FigureSaveName); 
close(VertTrialsOne); 




VertTrialTwo = figure('name','Vert Trials Part2'); 

for i = round((NumVertDefaults/2))+1 : NumReward 
    

    x = VertTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
    hold on; 
       
    VertDefaultIt = VertDefaultIts(i);
    StimTime = Timer(VertDefaultIt);
     
     EndRZ = RZEnds(i);
     RZEndTime = Timer(EndRZ)-StimTime;  
     
     StartRZ = RZStarts(i);
     RZStartTime = Timer(StartRZ)-StimTime;  
     
     RZSpan = [RZStartTime RZEndTime]; 
     Ys = [y y]; 
     
     plot(RZSpan, Ys, 'Color', [0 0.75 0], 'LineWidth', 6);
     Title = strcat(MouseName, '-', SeshNum, ':', 'Vertical Trials Part2'); 
     title(Title); 
     xlabel(XLabel); 
     ylabel(YLabel);
     
  hold on; 
    
    for a = 1:SpanLength
               
        LickPresent = VertLicksinSpan(i, a);  
        
        if LickPresent == 1
            
            LickTime = VertTimeofSpan(i, a); 
            plot(LickTime, y, 'k.', 'MarkerSize', 8);
            
        end 
    end  
    
    hold on; 
    
     RewardIt = RewardIts(i); 
     RewardTime = Timer(RewardIt)-StimTime; %time at that reward occurrence
     plot(RewardTime, y, 'r.', 'MarkerSize', 16); 
    
end 

FigureSaveName = 'Vert_Trials_Part2.png'; 
saveas(gcf, FigureSaveName); 
close(VertTrialTwo); 





YLabel = 'Speed (cm/s)'; 

%avg speed of trials 
AvgSpeedinSpanForVert = smooth(mean(VertSpeedinSpan, 1)); 
Height = max(AvgSpeedinSpanForVert); 
x = VertTimeofSpan(1, :); 

VertAvgSpeed = figure('name', 'Average Speed For Vert Stim in Session'); 
plot(x, AvgSpeedinSpanForVert); 
hold on; 
y = linspace(0, Height);  
plot(AvgRewardTime, y, 'r.'); 
plot(AvgRZStartTime, y, 'g.');
Title = strcat(MouseName, '-', SeshNum, ':', 'Average Speed For Vert Stim In Session'); 
title(Title); 
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Speed_For_Vert_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(VertAvgSpeed); 








Trials = (1:NumDiagStim);
YLabel = 'Trial'; 

DiagTrialsOne = figure('name','Diag Trials Part1'); 

for i = 1:round((NumDiagDefaults/2)) 
    
   
    x = DiagTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
       
    hold on;     
     
    DiagStimIt = DiagStimIts(i); 
    DiagStimTime = Timer(DiagStimIt); 
    
    DiagStimDist = TotalDist(DiagStimIt);
    EndDiagStim = find(TotalDist>= DiagStimDist + 55); 
    EndDiagStim = EndDiagStim(1); 
    
    EndDiagStimTime = Timer(EndDiagStim) - DiagStimTime; 
    
    DiagStimSpan = [0 EndDiagStimTime]; 
    Ys = [y y]; 
    
    plot(DiagStimSpan, Ys, 'r', 'LineWidth', 6);
    Title = strcat(MouseName, '-', SeshNum, ':', 'Diagonal Trials Part1'); 
    title(Title); 
    xlabel(XLabel); 
    ylabel(YLabel);

    hold on; 
    
        for z = 1:SpanLength
        
        LickPresent = DiagLicksinSpan (i, z);  
        
        if LickPresent == 1
            
            LickTime = DiagTimeofSpan(i, z); 
            plot(LickTime, y, 'k.', 'MarkerSize', 8);
            
        end 
        end  
    
        hold on; 
    
end 

FigureSaveName = 'Diag_Trials_Part1.png'; 
saveas(gcf, FigureSaveName); 
close(DiagTrialsOne); 



DiagTrialsTwo = figure('name','DiagTrials Part2'); 

for i = round((NumDiagDefaults/2))+1 : NumDiagDefaults 

      x = DiagTimeofSpan(1, :); 
    y = i; 
    plot(x, y); 
       
    hold on;     
     
    DiagStimIt = DiagStimIts(i); 
    DiagStimTime = Timer(DiagStimIt); 
    
    DiagStimDist = TotalDist(DiagStimIt);
    EndDiagStim = find(TotalDist>= DiagStimDist + 55); 
    EndDiagStim = EndDiagStim(1); 
    
    EndDiagStimTime = Timer(EndDiagStim) - DiagStimTime;
    
    DiagStimSpan = [0 EndDiagStimTime]; 
    Ys = [y y]; 
    
    plot(DiagStimSpan, Ys, 'r', 'LineWidth', 6);
    Title = strcat(MouseName, '-', SeshNum, ':', 'Diagonal Trials Part2'); 
    title(Title); 
    xlabel(XLabel); 
    ylabel(YLabel);
    
    hold on; 
    
        for z = 1:SpanLength
        
        LickPresent = DiagLicksinSpan (i, z);  
        
        if LickPresent == 1
            
            LickTime = DiagTimeofSpan(i, z); 
            plot(LickTime, y, 'k.', 'MarkerSize', 8);
            
        end 
    end  
       
end  

FigureSaveName = 'Diag_Trials_Part2.png'; 
saveas(gcf, FigureSaveName); 
close(DiagTrialsTwo); 



% 
% EndDiagStimTimes = zeros(NumDiagStim, 1); 
% 
% for i = 1:NumDiagStim
%     
%     DiagStimIt = DiagStimIts(i); 
%     DiagStimTime = Timer(DiagStimIt); 
%     
%     DiagStimDist = TotalDist(DiagStimIt);
%     EndDiagStim = find(AllDist>= DiagStimDist + 55); 
%     EndDiagStim = EndDiagStim(1); 
%     
%     EndDiagStimTime = Timer(EndDiagStim) - DiagStimTime;
%     EndDiagStimTimes(i, 1) = EndDiagStimTime; 
% 
% end 
% 
% 
% RewardTimes = zeros(NumReward, 1); 
% RZStartTimes = zeros(NumReward, 1); 
% 
% for i = 1: NumReward 
%     
%     VertDefaultIt =  VertDefaultIts(i);
%     StimTime = Timer(VertDefaultIt);
%     
%     RewardIt = RewardIts(i); 
%     RewardTime = Timer(RewardIt)-StimTime;
%     RewardTimes(i, 1) = RewardTime; 
%     
%     StartRZ = RZStarts(i);
%     RZStartTime = Timer(StartRZ)-StimTime; 
%     RZStartTimes(i, 1) = RZStartTime; 
%     
% end 


YLabel = 'Average Licks';
XLabel = 'Perstimulus Time'; 

% AvgRewardTime = mean(RewardTimes); 
% AvgRZStartTime = mean(RZStartTimes); 

% AvgEndDiagStimTime = mean(EndDiagStimTimes); 
AvgLicksinSpanForDiag = smooth(mean(DiagLicksinSpan, 1)); 

AvgLicksinSpanForVert = smooth(mean(VertLicksinSpan, 1));  
% Height = max(AvgLicksinSpanForVert); 
x = VertTimeofSpan(2, :); 

VertAvgLicks = figure('name', 'Average Licks For Vert vs Diag Stim In Session'); 
plot(x, AvgLicksinSpanForVert); 
hold on; 
plot(x, AvgLicksinSpanForDiag); 
legend('Vertical Stimuli', 'Diagonal Stimuli'); 
% y = linspace(0, Height);  
% plot(AvgRewardTime, y, 'r.'); 
% plot(AvgRZStartTime, y, 'g.'); 
% Title = strcat(MouseName, '-', SeshNum, ':', 'Average Licks For Vert Stim In Session'); 
% title(Title); 
xlabel(XLabel); 
ylabel(YLabel);

FigureSaveName = 'Average_Licks_For_Vert_vs_Diag_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(VertAvgLicks); 



YLabel = 'Average Licks'; 



Height = max(AvgLicksinSpanForDiag); 
x = DiagTimeofSpan(1, :); 

DiagAvgLicks = figure('name', 'Average Licks For Diag Stim InSession'); 
plot(x, AvgLicksinSpanForDiag); 
hold on; 
y = linspace(0, Height); 
plot(AvgEndDiagStimTime, y, 'r.'); 
 Title = strcat(MouseName, '-', SeshNum, ':', 'Average Licks For Diagonal Stim In Session'); 
    title(Title); 
    xlabel(XLabel); 
    ylabel(YLabel);
    
FigureSaveName = 'Average_Licks_For_Diag_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(DiagAvgLicks); 


SeshAvgLicks = figure('name', 'Average Licks For Session');
plot(x, AvgLicksinSpanForDiag, x, AvgLicksinSpanForVert);
hold on; 
plot(0, y, 'k.');
 Title = strcat(MouseName, '-', SeshNum, ':', 'Average Licks For Session'); 
    title(Title); 
    xlabel(XLabel); 
    ylabel(YLabel);
    
FigureSaveName = 'Average_Licks_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(SeshAvgLicks); 






YLabel = 'Speed (cm/s)';

%avg speed of trials 
AvgSpeedinSpanForDiag = smooth(mean(DiagSpeedinSpan, 1)); 
Height = max(AvgSpeedinSpanForDiag); 
x = DiagTimeofSpan(1, :) ;

DiagAvgSpeed = figure('name', 'Average Speed For Diag Stim in Session'); 
plot(x, AvgSpeedinSpanForDiag); 
hold on; 
y = linspace(0, Height); 
plot(AvgEndDiagStimTime, y, 'r.');
 Title = strcat(MouseName, '-', SeshNum, ':', 'Average Speed For Diagonal Stim In Session'); 
    title(Title); 
    xlabel(XLabel); 
    ylabel(YLabel);
 

FigureSaveName = 'Average_Speed_For_Diag_Stim_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(DiagAvgSpeed); 

DiagSeshSpeed = figure('name', 'Average Speed For Session'); 
plot(x, AvgSpeedinSpanForVert, x, AvgSpeedinSpanForDiag);
hold on; 
plot(0, y, 'k.'); 
 Title = strcat(MouseName, '-', SeshNum, ':', 'Average Speed For Session'); 
    title(Title); 
    xlabel(XLabel); 
    ylabel(YLabel);

    
FigureSaveName = 'Average_Speed_In_Session.png'; 
saveas(gcf, FigureSaveName); 
close(DiagSeshSpeed); 

cd(AnalysisPath); 
AccessPath = strcat(AnalysisPath, '\', 'FolderAccessed'); 
savepath AccessPath.txt; 



%calc behavioral d-prime 

Hits = nonzeros(Hits); 
numHits = length(Hits); 
HitFrac = numHits/NumReward; 


FalseAlarm = zeros(NumDiagStim, 1); 

for i = 1: NumDiagStim 
 
    DiagStimIt = DiagStimIts(i);    
    DiagStimDist = TotalDist(DiagStimIt);
    EndDiagStim = find(TotalDist>= DiagStimDist + 55); 
    EndDiagStim = EndDiagStim(1); 
    
    LickInDiag = find(Licks(DiagStimIt:EndDiagStim) == 1);  
    
    if isempty(LickInDiag) == 0
        
        LickIt = LickInDiag(1);
        FalseAlarm(i, 1) = LickIt; 
        
    end                
end 

NumFalseAlarm = length(FalseAlarm) 
FalseAlarmProb = NumFalseAlarm/NumDiagStim; 


else   %add code for deleting empty files 
    
%     FindDate = findstr(AnalysisPath, 'BH'); 
%     Date = AnalysisPath(FindDate+5:end); 
%     BustTrialPath = strcat(BustPath, Date); 
%     movefile(AnalysisPath, BustTrialPath);

    delete('*.dat');  
    cd(MouseFolderDataPath);
    rmdir(AnalysisPath); 
    
end 
end 



   



