%change size of world
    function [A,B,image1,r]=size_of_world (worldsize,r,A,B,image1,number_of_cell)
        %function size_of_world (~,~)
        % meni velikost miru
        answer='Yes';
        size=str2num(get(worldsize, 'String'));
        if (isempty(size))||(size<2)||(size~=round(size))   % zkontrolujeme ze size je kladne cele cislo
            errordlg('Type positive integer number')
            answer='No';
        else if size<16||size>500 %upozornim uzivatele ze pri moc male nebo velke velikosti programa muze fungovat neni spravne
                answer=questdlg('The program may operate abnormally. Are sure you want to continue with the given parameters?','Warning');
            end
        end
        if strcmp(answer,'Yes')
            r=size;                 % jestle vsechno vporadku menime velikost
            if r>length(A)                      % a podle toho,
                B=zeros(r,r);                   % vetsi minule velikosti nebo ne
            else
                B=zeros(length(A),length(A));   % menime matici
            end
            B(1:length(A),1:length(A))=A;
            B(r+1:end,:)=[];
            B(:,r+1:end)=[];
            A=B;
            try
            delete (image1); %odstranuje predchozi obrazek, jestli on byl
            end
            image1=imshow(A);                                 % zobrazeni matice     
            set(gca,'Position',[-0.117 0.005 0.99 0.99])      % pozice obrazu v figure
            set(number_of_cell,'String',num2str(sum(sum(A))));% pocet zivych bunek
            axis tight;                          % zobrazime novou matici
        else
            set(worldsize, 'String',r);         % a menime hodnotu v worldsize(uicontrol)
        end
    end
