function Game_of_life
% function zivot-hlavni funkce
% obsahuje v sebe funkci: startpause(~, ~)
% closebuttonpushed(~, ~)
% del(~, ~)
% changespeed(~,~)
% clearworld (~,~)
% generateworld(~,~)
% size_of_world (~,~)
% numofgen(~,~)
% graph (~,~)
% draw(~,~)
% status_of_button(status)
% vykrec(C)
% generace(numberofgen)

scrsize= get(0, 'ScreenSize'); % size of screen for figure's property
global f; % main figure
% property of figure
f=figure('MenuBar', 'none',...
    'Name', 'Game of Life',...% jmeno
    'Resize','off',...
    'CloseRequestFcn',@del,...% funkce pri zavreni figure
    'Position', [(scrsize(3)-scrsize(4)-140)/2 50 scrsize(4)+140 scrsize(4)-80],...% pozice
    'NumberTitle', 'off');


%button start/pause function generase

start=uicontrol('Style','PushButton',...        % styl uicontrol
    'Position', [(scrsize(4)-30) 20 70 25],...  % pozice
    'String', 'Start',...                       % string
    'CallBack', @startpause);         % callback

%start or pause function generace
    function startpause (~, ~)
        % function startpause
        if strcmp(get(start, 'String'),'Start'); % urcuje string na tlacitke
            set(start,'String','Pause');         % meni se na opacny (start/pause)
            condition=1;                        % podminka pro generace - 1
            status_of_button('off',generatematrix,worldsize,closebutton,speedslider,clearworldbutton,graphics,numofgeneration,draw_button);            % vypina vsechny uicontrol mimo "start"
            j=str2double(get(numofgeneration,'String'));% zapisuje v promennou j pocet generace
            generace(j-1);                      % spousti funkce generce
        else                                % jinak
            status_of_button('on',generatematrix,worldsize,closebutton,speedslider,clearworldbutton,graphics,numofgeneration,draw_button);             % zapina vsechny uicontrol
            set(start,'String','Start');        % meni se na opacny start/pause
            condition=0;                        % podminka pro generace - 0
            vykres(A);                          % zobrazuje matice
        end
    end


% close figure
closebutton=uicontrol('Style','PushButton',...  % styl uicontrol
    'Position', [ (scrsize(4)+50) 20 70 25],... % pozice
    'String', 'Close',...                       % string
    'CallBack', @closebuttonpushed);            % callback

% close game
    function closebuttonpushed (~, ~)
        %function closebuttonpushed
        %zavira figure,pouziva funkce del()
        condition=0;            % podminka pro generace - 0
        close (f);
    end

%delete figure
    function del(~, ~)
        if strcmp(get(start, 'String'),'Pause') % jestli jde generace()
            startpause();                       % prerusi cyklus
        end
        answer=questdlg('Are you sure?','Game of Life'); % pta uzivatele
        if strcmp(answer,'Yes')
            delete(f);
        end
    end


%speed slider
speedslider=uicontrol('Style','Slider',...      % styl uicontrol
    'Position', [(scrsize(4)-30) 55 150 20],... % pozice
    'Value', 50,...                             % primarni hodnota
    'CallBack', @changespeed,...                % callback
    'Min', 1,...                                % minimalni hodnota
    'Max', 100);                                % maximalni hodnota

%speed changes
    function changespeed(~,~)
        % function changespeed(~,~)
        % zmena rychlosti cykla
        s=get(speedslider,'Value');
        speed=1/s;
    end

speedhint=uicontrol('Style','Edit',...      % styl uicontrol
    'String','Speed bar',...                % string
    'enable', 'off',...
    'Position',[(scrsize(4)-30) 85 70 20]); % pozice


%clear world
clearworldbutton=uicontrol('Style','PushButton',...% styl uicontrol
    'String','Clear',...                           % string
    'Position',[(scrsize(4)+50) 85 70 25],...      % pozice
    'CallBack',@clearworld);                       % callback

%generate clear word size r x r
    function clearworld (~,~)
        %function clearworld (~,~)
        %cisti mir
        A=zeros(r,r);               % cisti maticu A
        vykres(A)                  % zobrazi cistou matice
        B=A;                        % cisti maticu B
        m=[];                       % cisti masiv pro graf()
    end


%button generate random world
generatematrix=uicontrol('Style','PushButton',...% styl uicontrol
    'String', 'Generate random world',...        % string
    'Position', [(scrsize(4)-30) 120 150 25],... % pozice
    'CallBack', @generateworld);                 % callback

%generate random world size r x r
    function generateworld(~,~)
        %function generateworld(~,~)
        % generuje nahodny mir
        r=str2double(get(worldsize,'String'));
        U=rand(r,r);    % nahodna matice
        p=0.25;
        A=(U<p);        % nova matice A
        vykres(A)      % zobrazeni
        m=[];           % cisti masiv m pro graf()
        B=A;
    end


world_size_text=uicontrol('Style','Edit',...   % styl uicontrol
    'String','Size of World',...               % string
    'enable', 'off',...
    'Position',[(scrsize(4)-30) 155 70 25]);   % pozice

%change worldsize
worldsize=uicontrol('Style', 'Edit',...        % styl uicontrol
    'String','30',...                          % primarni hodnota
    'Position', [(scrsize(4)+50) 155 70 25],...% pozice
    'CallBack', @sss);               % callback

    function sss(~,~)
        [A,B,image1,r]=size_of_world(worldsize,r,A,B,image1,number_of_cell);
    end

number_of_cells_text=uicontrol('Style','Edit',...% styl uicontrol
    'String','Live cell:',...                    % string
    'enable', 'off',...
    'Position',[(scrsize(4)-30) 190 70 25]);     % pozice

number_of_cell=uicontrol('Style','Edit',...      % styl uicontrol
    'enable', 'off',...
    'Position',[(scrsize(4)+50) 190 70 25]);     % pozice


num_of_generation_text=uicontrol('Style','Edit',... % styl uicontrol
    'String','Genertion:',...                    % string
    'enable', 'off',...
    'Position',[(scrsize(4)-30) 225 70 25]);     % pozice

numofgeneration=uicontrol('Style','Edit',...     % styl uicontrol
    'Position', [(scrsize(4)+50) 225 70 25],...  % pozice
    'String', '20',...                           % hodnota
    'CallBack',@numofgen);                       % callback

% number of generation
    function numofgen(~,~)
        u=get(numofgeneration,'String');
        if strcmp(u,'inf')      %jestli numofgeneration(uicontrol)=inf, podminka por generaci() bude inf
            condition='inf';
        else if (isempty(str2num(u)))||(str2double(u)~=round(str2double(u))) % jinak, jestli neni kladne cele cislo
                errordlg('Type a positive integer number or inf','Error')   % zobrazime okno error
                set(numofgeneration,'String',j);
            else
                condition=1;    % vsechno dobre - podminka pro funkce generace() - 1
            end
        end
    end


%graphic
graphics=uicontrol('Style','PushButton',...    % styl uicontrol
    'Position', [(scrsize(4)-30) 260 70 25],...% pozice
    'String', 'Graph',...                      % string
    'CallBack',@graph);                       % callback

% graph of population
    function graph (~,~)
        % function graph (~,~)
        % kresli graf zavislosti poctu zivych bunek na case
        if ~isempty(m)                           % jestli masiv m neni prazdny
            f1=figure('MenuBar', 'none',...      % udelame graf
                'Name', 'Game of Life Graph',...                                                % jmeno
                'Resize','off',...
                'Position', [(scrsize(3)-scrsize(4)-140)/2 50 scrsize(4)+140 scrsize(4)-80],... % pozice
                'NumberTitle', 'off');
            plot( 1:num, m) % kresleni grafu
        else                                     %jinak zobrazim okno error
            errordlg('Not enough values ??for the construction of a graph','Error')
        end
    end


draw_button=uicontrol('Style','Pushbutton',...% styl
    'String','Draw',...                       % string
    'Position',[(scrsize(4)+50) 260 70 25],...% pozice
    'Callback',@draw);                        % callback

% draw cell
    function draw(~,~)
        %function draw(~,~)
        condition1=1;               % podminka pro while
        vykres(B)                   % zobrazeni obrazku matice
        status_of_button('off',generatematrix,worldsize,closebutton,speedslider,clearworldbutton,graphics,numofgeneration,draw_button);    % vypina tlacitka
        set(start,'enable', 'off');
        k=uicontrol('Style','Edit',...                   % styl
            'Enable','off',...                           % vypnute
            'String','Click here to cancel changes',...  % String
            'Position',[(scrsize(4)-30) 300 150 100]);   % pozice
        k1=uicontrol('Style','Edit',...                  % styl
            'Enable','off',...                           % vypnute
            'String','Click here to save the changes',...% String
            'Position',[(scrsize(4)-30) 450 150 100]);   % pozice
        while condition1
            f;                      % ve figere f
            image1;                 % v image
            [x, y]=ginput(1);       % spoustime kresleni
            x=round(x);             % zapamatujeme si souradnice x
            y=round(y);             % a y
            try
                if B(y,x)               %zkusime zmenit maticu B
                    B(y,x)=0;
                else
                    B(y,x)=1;
                end
            catch                       %jestli jsme prekrocili hranice
                if (x/r>1.078)&&(x/r<1.298)&&(((y/r>0.422)&&(y/r<0.566))||((y/r>0.202)&&(y/r<0.346)))
                    if (x/r>1.078)&&(x/r<1.298)&&(y/r>0.202)&&(y/r<0.346)
                        A=B;            %ale souradnice ukazuje na obdelniky
                    end                 %tehdy zavrime tu funkce a ulozime zmeny nebo ne
                    condition1=0;
                    status_of_button('on',generatematrix,worldsize,closebutton,speedslider,clearworldbutton,graphics,numofgeneration,draw_button);   % zapneme tlacitka
                    set(start,'enable', 'on')
                    delete(k)                 % smazeme pomocne uicontrol(obdelniky)
                    delete(k1)
                end                     %jinak prodlouzime kreslit
            end
            vykres(B) % nakresli maticu B, zmena v cyklu
        end
        vykres(B); % nakresli maticu A, zmena vne cyklu, konecny vysledek
    end

    function vykres(C)
        %function risunok(C)
        %C: matice A nebo B pro zobrazeni obrazku matice
        image1=imshow(C);                                 % zobrazeni matice     
        set(gca,'Position',[-0.117 0.005 0.99 0.99])      % pozice obrazu v figure
        set(number_of_cell,'String',num2str(sum(sum(C))));% pocet zivych bunek
        axis tight;                                       % zachovoni rozsahu
        B=C;                                              % aktualizace matice B
    end

global condition    % podminka pro funkci generace()
condition=1;
global condition1   % podminka pro funkci draw()
global j            % pocet generaci
j=20;
global m            % masiv poctu zivych bunek
m=[];
global num          % citac pro matice
num=0;
global image1;      % obraz sv?ta
global A;           % pocatecni matice se kterou se hraje
global B;           % pomocna matice
global r;           % velikost sveta
global speed;       % rychlost

generateworld();    % vytvari mir s puvodnimi parametry

    function generace(numberofgen)
        % function generace(numberofgen)
        % numberofgen: pocet generaci bunek a pocet prochazeni cyklem while
        while condition==1||strcmp(condition,'inf')
            for x=0:r-1
                for y=0:r-1
                    okoli=A(rem(x-1+r,r)+1,rem(y-1+r,r)+1)+A(rem(x-1+r,r)+1,rem(y+r,r)+1)+A(rem(x-1+r,r)+1,rem(y+1+r,r)+1)+A(rem(x+r,r)+1,rem(y-1+r,r)+1)+A(rem(x+r,r)+1,rem(y+1+r,r)+1)+A(rem(x+1+r,r)+1,rem(y-1+r,r)+1)+A(rem(x+1+r,r)+1,rem(y+r,r)+1)+A(rem(x+1+r,r)+1,rem(y+1+r,r)+1); %v?po?et okoli bu?ky takovy, aby mohla p?ekro?it hranici a dostat se na opa?nou stranu, stejne jako ve hre Had
                    if A(x+1,y+1)==1        % v pripade, ze bunka je ziva
                        if okoli==2 || okoli==3 % a v okoli 2 nebo 3 zive
                            B(x+1,y+1)=1;   % zustane
                        else                % jinak
                            B(x+1,y+1)=0;   % zahyne
                        end
                    else                    % mrtva bunka
                        if okoli==3         % a v okoli 3 zive
                            B(x+1,y+1)=1;   % ozije
                        else                % jinak
                            B(x+1,y+1)=0;   % neozije
                        end
                    end
                end
            end
            hold on
            num=num+1;          % zvyseni hodnoty citaca
            m(num)=sum(sum(B)); % zapis poctu zivych bunek do masiv
            if (A==B)           % kontrola totoznosti nove a predchozi matici
                warndlg('Running has stopped because the grid in steady state','Steady state')
                try
                  delete (image1); %odstranuje predchozi obrazek, jestli on byl
                end
                image1=imshow(A); % obrazek matice
                startpause();
            end;                             % nepouzival jsem funkci vykres(), protoze bez ni cykl pracuje rychlej
            A=B;
            try
                delete (image1);             % odstranuje predchozi obrazek,jestli on byl
            end
            image1=imshow(A);                % zobrazeni matice
            set(number_of_cell,'String',num2str(sum(sum(A))));% pocet zivych bunek
            pause(speed);                    % pauza,ktera zavisla na rychlosti
            drawnow;                         % okamzite zobrazeni
            if condition                     % podminky pro zmenu hodnoty poctu generaci bunek
                if numberofgen==0
                    condition=0;
                    startpause()
                else
                    numberofgen=numberofgen-1;
                end
            end
            set(numofgeneration,'String',numberofgen)
        end
        set(numofgeneration,'String',j)
    end

end
