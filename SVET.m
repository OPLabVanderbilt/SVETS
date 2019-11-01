%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SVET task
% created by Mackenzie Aug 2017 to run for OPlus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    %% Open Screen
    Screen('Preference', 'SkipSyncTests', 1); %only for running on a laptop
    whichScreen = 1; %changed to 1 to test on laptop
    [w, rect] = Screen('OpenWindow', whichScreen, 255);
    sc_length = rect(3);
    sc_height = rect(4);
    yc = rect(4)/2; %y-center
    xc = rect(3)/2; %x-center
    Screen('FillRect', w, [255 255 255]); % set screen to white
    Screen('Flip',w);
    
    subjno = '000';
    subjini = 'mas';
    %     hand = hand;
    %     age = age;
    %     sex = sex;
    
    key1 = KbName('1!'); key2 = KbName('2@'); key3 = KbName('3#'); %makes it so you use the number pad
    key4 = KbName('4$'); key5 = KbName('5%'); key6 = KbName('6^');
    key7 = KbName('7&'); key8 = KbName('8*'); key9 = KbName('9(');
    spaceBar = KbName('space');
    esc_key = KbName('escape'); %this key will kill the script during the experiment
    
    category = 't'; % sets category
    if strcmp(category, 'b')
        cat_name = 'bird';
        instruct_line = 'a bird in North America.';
    elseif strcmp(category, 'p')
        cat_name = 'airplane model';
        instruct_line = 'an airplane model.';
    else strcmp(category, 't')
        cat_name = 'Transformer';
        instruct_line = 'a Transformer, a character from the fictional Transformers series of toys, stories, and movies.';
    end
    
    Screen(w, 'TextSize', 24);
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextStyle', 1);
    
    commandwindow; %get back to command window
    
    %% create files for saving data
    cd('data_SVET')
    fileName1 = ['SVET_' num2str(subjno) '_' subjini '_' category '.txt'];
    dataFile1 = fopen(fileName1, 'w');
    cd('..')
    
    fprintf(dataFile1, ['\nsubjno\tsubjini\ttrialnum\ttrialtype\tName1\tName2\tName3\ttarloc\tresp\tac\trt']); %prints headers
    
    ListenChar(2);
    % HideCursor;
    commandwindow;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Instructions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen('Flip', w);
    center_text(w, ['In this task you will have to select the REAL ' cat_name ' name.'], 0, -100);
    center_text(w, 'On each trial, 3 names will be presented.', 0, -50);
    center_text(w, ['Only 1 name is the REAL common name of ' instruct_line], 0, 0);
    center_text(w, ['Choose the name that you think is the real ' cat_name ' common name in each set.'], 0, 50);
    center_text(w, ['To respond, press the number corresponding to you choice on the number pad.'], 0, 100);
    center_text(w, 'Press the spacebar to begin.', 0, 200);
    Screen('Flip', w);
    
    FlushEvents('keyDown');
    responsecode = [];
    temp = 0;
    responsecode = 0;
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            responsecode = find(keyCode);
            if responsecode == KbName('space')
                break
            end
        end
    end
    while KbCheck; end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Experimental Trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [cat trial trialtype Name1 Name2 Name3 tarloc] = textread(['trials_' category '.txt'], '%s %u %s %s %s %s %u','delimiter','\t');
    
    ntrials = length(trial); %should get the number of trials
    for m = 1:ntrials
        
        %draw box
        Screen('Flip', w);
        Screen('DrawLine',w,[127],xc-600,yc+200,xc+600,yc+200);
        Screen('DrawLine',w,[127],xc-600,yc-200,xc+600,yc-200);
        Screen('DrawLine',w,[127],xc-600,yc+200,xc-600,yc-200);
        Screen('DrawLine',w,[127],xc+600,yc-200,xc+600,yc+200);
        Screen('DrawLine',w,[127],xc-200,yc+200,xc-200,yc-200);
        Screen('DrawLine',w,[127],xc+200,yc+200,xc+200,yc-200);
        
        %gets the length of the text bounds so that you can center the text
        bbox = Screen('TextBounds',w, Name1{m});
        Name1_length = bbox(3);
        bbox = Screen('TextBounds',w, Name2{m});
        Name2_length = bbox(3);
        bbox = Screen('TextBounds',w, Name3{m});
        Name3_length = bbox(3);
        
        %draws text
        [nx, ny, bbox] = DrawFormattedText(w, Name1{m}, xc-(400+(Name1_length/2)), yc-50);
        [nx, ny, bbox] = DrawFormattedText(w, Name2{m}, 'center', yc-50);
        [nx, ny, bbox] = DrawFormattedText(w, Name3{m}, xc+(400-(Name3_length/2)), yc-50);
        
        %draws numbers for respons options
        [nx, ny, bbox] = DrawFormattedText(w, '1', xc-400, yc+50);
        [nx, ny, bbox] = DrawFormattedText(w, '2', 'center', yc+50);
        [nx, ny, bbox] = DrawFormattedText(w, '3', xc+400, yc+50);
        Screen('Flip', w);
        
        FlushEvents('keyDown');
        temp = 0;
        rt = GetSecs;
        responsecode = 0;
        
        %record response time
        resp1 = KbName('1');
        resp2 = KbName('2');
        resp3 = KbName('3');
        GoOn = 0;
        keyIsDown = 0;
        while GoOn == 0;
            temp = GetSecs-rt;
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                responsecode = find(keyCode);
                if responsecode == resp1 || responsecode == resp2 || responsecode == resp3
                    keyIsDown = 0;
                    GoOn = 1;
                end
                if responsecode == KbName('q')
                    Screen('CloseAll');
                end
            end
        end
        
        rt = secs-rt;
        rt = rt*1000;
        
        %set response for output file
        if responsecode == resp1
            response = 1;
        elseif responsecode == resp2
            response = 2;
        elseif responsecode == resp3
            response = 3;
        end
        
        %set correct response for outputfile
        if response == tarloc(m)
            GradedRes = 1;
        else
            GradedRes = 0;
        end
        
        
        %print data
        fprintf(dataFile1, ('\n%s\t%s\t%d\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%f'),...
            subjno,subjini,m,trialtype{m},Name1{m},Name2{m},Name3{m},tarloc(m),response,GradedRes,rt);
        
        FlushEvents('keyDown');
        WaitSecs(.5);
        touch=0;
    end
    
    
    Screen('Flip', w);
    center_text(w, 'You have finished this task!', 0);
    center_text(w, 'Press the spacebar', 0, 50);
    Screen('Flip', w);
    WaitSecs(.2);
    responsecode = [];
    temp = 0;
    responsecode = 0;
    
    % Press any key to quit the program
    FlushEvents('keyDown');
    pressKey = KbWait;
    
    ShowCursor;
    Screen('CloseAll');
    
    ListenChar;
    
catch
    ListenChar(0);
    ShowCursor;
    Screen('CloseAll');
    rethrow(lasterror);
end

%end
